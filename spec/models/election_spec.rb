require 'rails_helper'

describe Election do
  let!(:questionnaire)              { FactoryBot.create(:questionnaire, skip_create_sections: true) }
  let!(:questionnaire_section_1)    { FactoryBot.create(:questionnaire_section, questionnaire: questionnaire, order_index: 1, title: 'Section 1', skip_create_questions: true) }

  let!(:ranked_choice_question)     { FactoryBot.create(:question, questionnaire_section: questionnaire_section_1, question_type: Question::QUESTION_TYPE_RANKED_CHOICE, order_index: 1) }
  let!(:ranked_choice_1)            { FactoryBot.create(:choice, question: ranked_choice_question, title: 'ranked choice 1', order_index: 1) }
  let!(:ranked_choice_2)            { FactoryBot.create(:choice, question: ranked_choice_question, title: 'ranked choice 2', order_index: 2) }
  let!(:ranked_choice_3)            { FactoryBot.create(:choice, question: ranked_choice_question, title: 'ranked choice 2', order_index: 3) }
  let!(:ranked_choice_4)            { FactoryBot.create(:choice, question: ranked_choice_question, title: 'ranked choice 2', order_index: 4) }

  let!(:multiple_choice_question)   { FactoryBot.create(:question, questionnaire_section: questionnaire_section_1, question_type: Question::QUESTION_TYPE_CHECKBOXES, order_index: 2) }
  let!(:multiple_choice_1)          { FactoryBot.create(:choice, question: multiple_choice_question, title: 'checkbox choice 1', order_index: 1) }
  let!(:multiple_choice_2)          { FactoryBot.create(:choice, question: multiple_choice_question, title: 'checkbox choice 2', order_index: 2) }

  let(:ranked_choice_answer_1)      { FactoryBot.create(:answer, question: ranked_choice_question, text: '0:::1:::2:::3', order_index: 1, answerable: FactoryBot.create(:vote_completion) ) }
  let(:ranked_choice_answer_2)      { FactoryBot.create(:answer, question: ranked_choice_question, text: '0:::1:::3:::2', order_index: 2, answerable: FactoryBot.create(:vote_completion)) }
  let(:ranked_choice_answer_3)      { FactoryBot.create(:answer, question: ranked_choice_question, text: '1:::0:::2:::3', order_index: 3, answerable: FactoryBot.create(:vote_completion)) }
  let(:ranked_choice_answer_3dq)    { FactoryBot.create(:answer, question: ranked_choice_question, text: '1:::0:::2:::3', order_index: 3, answerable: FactoryBot.create(:vote_completion, :disqualified)) }

  # adding in these two requires a second round where 3's vote gives the election to 2 (because of the 2nd place vote for 2)
  let(:ranked_choice_answer_4)      { FactoryBot.create(:answer, question: ranked_choice_question, text: '1:::0:::2:::3', order_index: 4, answerable: FactoryBot.create(:vote_completion)) }
  let(:ranked_choice_answer_5)      { FactoryBot.create(:answer, question: ranked_choice_question, text: '2:::1:::0:::3', order_index: 5, answerable: FactoryBot.create(:vote_completion)) }

  # adding in these two requires a third round where 3's vote gives the election to 2 (because of the 2nd place vote for 2)
  let(:ranked_choice_answer_6)      { FactoryBot.create(:answer, question: ranked_choice_question, text: '3:::1:::2:::0', order_index: 6, answerable: FactoryBot.create(:vote_completion)) }
  let(:ranked_choice_answer_7)      { FactoryBot.create(:answer, question: ranked_choice_question, text: '1:::2:::0:::3', order_index: 7, answerable: FactoryBot.create(:vote_completion)) }
  let(:ranked_choice_answer_8)      { FactoryBot.create(:answer, question: ranked_choice_question, text: '3:::1:::0:::2', order_index: 8, answerable: FactoryBot.create(:vote_completion)) }
  let(:ranked_choice_answer_9)      { FactoryBot.create(:answer, question: ranked_choice_question, text: '3:::1:::0:::2', order_index: 9, answerable: FactoryBot.create(:vote_completion)) }

  let(:empty_ranked_choice_answer)  { FactoryBot.create(:answer, question: ranked_choice_question, text: '-:::-:::-:::-', order_index: 1, answerable: FactoryBot.create(:vote_completion)) }

  let(:incomplete_ranked_choice_answer_1) { FactoryBot.create(:answer, question: ranked_choice_question, text: '0:::1:::-:::-', order_index: 1, answerable: FactoryBot.create(:vote_completion)) }
  let(:incomplete_ranked_choice_answer_2) { FactoryBot.create(:answer, question: ranked_choice_question, text: '0:::1:::-:::2', order_index: 2, answerable: FactoryBot.create(:vote_completion)) }
  let(:incomplete_ranked_choice_answer_3) { FactoryBot.create(:answer, question: ranked_choice_question, text: '1:::0:::2:::3', order_index: 3, answerable: FactoryBot.create(:vote_completion)) }

  # adding in these two requires a second round where 3's vote gives the election to 2 (because of the 2nd place vote for 2)
  let(:incomplete_ranked_choice_answer_4) { FactoryBot.create(:answer, question: ranked_choice_question, text: '1:::0:::2:::3', order_index: 4, answerable: FactoryBot.create(:vote_completion)) }
  let(:incomplete_ranked_choice_answer_5) { FactoryBot.create(:answer, question: ranked_choice_question, text: '0:::1:::-:::2', order_index: 5, answerable: FactoryBot.create(:vote_completion)) }
  let(:incomplete_ranked_choice_answer_6) { FactoryBot.create(:answer, question: ranked_choice_question, text: '1:::0:::2:::3', order_index: 6, answerable: FactoryBot.create(:vote_completion)) }
  let(:incomplete_ranked_choice_answer_7) { FactoryBot.create(:answer, question: ranked_choice_question, text: '-:::-:::0:::-', order_index: 7, answerable: FactoryBot.create(:vote_completion)) }
  let(:incomplete_ranked_choice_answer_8) { FactoryBot.create(:answer, question: ranked_choice_question, text: '-:::1:::0:::-', order_index: 8, answerable: FactoryBot.create(:vote_completion)) }

  let(:multiple_choice_answer_1)    { FactoryBot.create(:answer, question: multiple_choice_question, text: 'checkbox choice 1', answerable: FactoryBot.create(:vote_completion)) }
  let(:multiple_choice_answer_2)    { FactoryBot.create(:answer, question: multiple_choice_question, text: 'checkbox choice 2', answerable: FactoryBot.create(:vote_completion)) }
  let(:multiple_choice_answer_3)    { FactoryBot.create(:answer, question: multiple_choice_question, text: 'checkbox choice 2', answerable: FactoryBot.create(:vote_completion)) }
  let(:multiple_choice_answer_4)    { FactoryBot.create(:answer, question: multiple_choice_question, text: 'checkbox choice 1:::checkbox choice 2', answerable: FactoryBot.create(:vote_completion)) }

  let(:election)                    { FactoryBot.create(:election, :internal, questionnaire: questionnaire) }

  describe "#tally_answers" do
    context "when testing complete ranked choice votes" do
      context "when the first place vote getting gets above the threshold" do
        before do
          ranked_choice_answer_1; ranked_choice_answer_2; ranked_choice_answer_3
        end

        it "counts the choices correctly" do
          election.tally_answers

          expect(questionnaire.choice_tallies.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "1", round: 1).first.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "2", round: 1).first.count).to eq(1)

          expect(ranked_choice_question.num_rounds).to eq(1)
          expect(ranked_choice_question.winner).to eq(ranked_choice_1)
        end
      end

      context "when the first place vote getting gets above the threshold while ignoring disqualified votes" do
        before do
          ranked_choice_answer_1; ranked_choice_answer_2; ranked_choice_answer_3; ranked_choice_answer_3dq
        end

        it "counts the choices correctly" do
          election.tally_answers

          expect(questionnaire.choice_tallies.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "1", round: 1).first.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "2", round: 1).first.count).to eq(1)

          expect(ranked_choice_question.num_rounds).to eq(1)
          expect(ranked_choice_question.winner).to eq(ranked_choice_1)
        end
      end

      context "when it requires a 2nd round" do
        before do
          ranked_choice_answer_1; ranked_choice_answer_2; ranked_choice_answer_3
          ranked_choice_answer_4; ranked_choice_answer_5
        end

        it "counts the choices correctly" do
          election.tally_answers

          expect(questionnaire.choice_tallies.where(round: 1).count).to eq(3)
          expect(questionnaire.choice_tallies.where(value: "1", round: 1).first.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "2", round: 1).first.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "3", round: 1).first.count).to eq(1)

          expect(questionnaire.choice_tallies.where(round: 2).count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "1", round: 2).first.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "2", round: 2).first.count).to eq(3)

          expect(ranked_choice_question.num_rounds).to eq(2)
          expect(ranked_choice_question.winner).to eq(ranked_choice_2)
        end
      end

      context "when it requires a 3nd round" do
        before do
          ranked_choice_answer_1; ranked_choice_answer_2; ranked_choice_answer_3
          ranked_choice_answer_4; ranked_choice_answer_5
          ranked_choice_answer_6; ranked_choice_answer_7; ranked_choice_answer_8; ranked_choice_answer_9
        end

        it "counts the choices correctly" do
          election.tally_answers

          expect(questionnaire.choice_tallies.where(round: 1).count).to eq(4)
          expect(questionnaire.choice_tallies.where(value: "1", round: 1).first.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "2", round: 1).first.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "3", round: 1).first.count).to eq(4)
          expect(questionnaire.choice_tallies.where(value: "4", round: 1).first.count).to eq(1)

          expect(questionnaire.choice_tallies.where(round: 2).count).to eq(3)
          expect(questionnaire.choice_tallies.where(value: "1", round: 1).first.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "2", round: 2).first.count).to eq(3)
          expect(questionnaire.choice_tallies.where(value: "3", round: 2).first.count).to eq(4)

          expect(questionnaire.choice_tallies.where(round: 3).count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "2", round: 3).first.count).to eq(5)
          expect(questionnaire.choice_tallies.where(value: "3", round: 3).first.count).to eq(4)

          expect(ranked_choice_question.num_rounds).to eq(3)
          expect(ranked_choice_question.winner).to eq(ranked_choice_2)
        end
      end
    end

    context "when testing incomplete ranked choice votes" do
      context "when there are no votes" do
        before do
          empty_ranked_choice_answer
        end

        it "counts the choices correctly" do
          election.tally_answers

          expect(questionnaire.choice_tallies.count).to eq(0)
          expect(ranked_choice_question.num_rounds).to eq(0)
          expect(ranked_choice_question.winner).to be_nil
        end
      end

      context "when the first place vote getting gets above the threshold" do
        before do
          incomplete_ranked_choice_answer_1; incomplete_ranked_choice_answer_2; incomplete_ranked_choice_answer_3
          empty_ranked_choice_answer
        end

        it "counts the choices correctly" do
          election.tally_answers

          expect(questionnaire.choice_tallies.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "1", round: 1).first.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "2", round: 1).first.count).to eq(1)

          expect(ranked_choice_question.num_rounds).to eq(1)
          expect(ranked_choice_question.winner).to eq(ranked_choice_1)
        end
      end

      context "when it requires a 2nd round" do
        before do
          incomplete_ranked_choice_answer_1; incomplete_ranked_choice_answer_2; incomplete_ranked_choice_answer_3
          incomplete_ranked_choice_answer_4; incomplete_ranked_choice_answer_5; incomplete_ranked_choice_answer_6
          incomplete_ranked_choice_answer_7; incomplete_ranked_choice_answer_8
        end

        it "counts the choices correctly" do
          election.tally_answers

          expect(questionnaire.choice_tallies.where(round: 1).count).to eq(3)
          expect(questionnaire.choice_tallies.where(value: "1", round: 1).first.count).to eq(3)
          expect(questionnaire.choice_tallies.where(value: "2", round: 1).first.count).to eq(3)
          expect(questionnaire.choice_tallies.where(value: "3", round: 1).first.count).to eq(2)

          expect(questionnaire.choice_tallies.where(round: 2).count).to eq(3)
          expect(questionnaire.choice_tallies.where(value: "1", round: 2).first.count).to eq(3)
          expect(questionnaire.choice_tallies.where(value: "2", round: 2).first.count).to eq(4)
          expect(questionnaire.choice_tallies.where(value: nil, round: 2).first.count).to eq(1)

          expect(ranked_choice_question.num_rounds).to eq(2)
          expect(ranked_choice_question.winner).to eq(ranked_choice_2)
        end
      end
    end

    context "when testing multiple choice votes" do
      context "when the first place vote getting gets above the threshold" do
        before do
          multiple_choice_answer_1; multiple_choice_answer_2; multiple_choice_answer_3; multiple_choice_answer_4
        end

        it "counts the choices correctly" do
          election.tally_answers

          expect(questionnaire.choice_tallies.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "checkbox choice 1").first.count).to eq(2)
          expect(questionnaire.choice_tallies.where(value: "checkbox choice 2").first.count).to eq(3)
        end
      end
    end
  end
end

