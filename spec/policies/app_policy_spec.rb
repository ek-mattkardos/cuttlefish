require 'spec_helper'

describe AppPolicy do
  # TODO Test effect of read only mode
  
  subject { AppPolicy.new(user, app) }

  let(:team_one) { FactoryGirl.create(:team) }
  let(:team_two) { FactoryGirl.create(:team) }

  let(:app) { FactoryGirl.create(:app, team: team_one) }

  context "normal user in team one" do
    let(:user) { FactoryGirl.create(:admin, team: team_one)}
    it { is_expected.to permit(:show) }
    it { is_expected.to permit(:create) }
    it { is_expected.to permit(:new) }
    it { is_expected.to permit(:update)  }
    it { is_expected.to permit(:edit)    }
    it { is_expected.to permit(:destroy) }
    it { is_expected.to permit(:dkim) }
    it { is_expected.to permit(:toggle_dkim) }
  end

  context "normal user in team two" do
    let(:user) { FactoryGirl.create(:admin, team: team_two)}
    it { is_expected.not_to permit(:show) }
    it { is_expected.to permit(:create) }
    it { is_expected.to permit(:new) }
    it { is_expected.not_to permit(:update)  }
    it { is_expected.not_to permit(:edit)    }
    it { is_expected.not_to permit(:destroy) }
    it { is_expected.not_to permit(:dkim) }
    it { is_expected.not_to permit(:toggle_dkim) }
  end

  context "super admin in team two" do
    let(:user) { FactoryGirl.create(:admin, team: team_two, super_admin: true)}
    it { is_expected.to permit(:show) }
    it { is_expected.to permit(:create) }
    it { is_expected.to permit(:new) }
    it { is_expected.not_to permit(:update)  }
    it { is_expected.not_to permit(:edit)    }
    it { is_expected.not_to permit(:destroy) }
    it { is_expected.not_to permit(:dkim) }
    it { is_expected.not_to permit(:toggle_dkim) }

    context "cuttlefish app" do
      let(:app) { App.cuttlefish }
      it { is_expected.to permit(:show) }
      it { is_expected.to permit(:create) }
      it { is_expected.to permit(:new) }
      it { is_expected.not_to permit(:update)  }
      it { is_expected.not_to permit(:edit)    }
      it { is_expected.not_to permit(:destroy) }
      it { is_expected.to permit(:dkim) }
      it { is_expected.to permit(:toggle_dkim) }
    end
  end
end
