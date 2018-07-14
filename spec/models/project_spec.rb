require 'rails_helper'

RSpec.describe Project, type: :model do
  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    owner = FactoryBot.create(:owner)
    project = FactoryBot.create(:project, name: "Test Project", owner: owner)
    new_project = FactoryBot.build(:project, name: "Test Project", owner: owner)

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  # 二人のユーザーが同じ名前を使うことは許可すること
  it "allows two users to share a project name" do
    owner = FactoryBot.create(:owner)
    project = FactoryBot.create(:project, name: "Test Project", owner: owner)

    other_owner = FactoryBot.create(:owner, email: "janetester@example.com")
    other_project = FactoryBot.create(:project, name: "Test Project", owner: other_owner)

    expect(other_project).to be_valid
  end

  # 遅延ステータス
  describe "late status" do
    # 締切日が過ぎていれば遅延していること
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    # 締切日が今日ならスケジュールどおりであること
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    # 締切日が未来ならスケジュールどおりであること
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end

  # たくさんのメモが付いていること
  it "can have many notes" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end
end
