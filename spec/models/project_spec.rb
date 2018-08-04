require 'rails_helper'

RSpec.describe Project, type: :model do
  # ユーザー単位では重複したプロジェクト名を許可しないこと
  # 二人のユーザーが同じ名前を使うことは許可すること
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

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
