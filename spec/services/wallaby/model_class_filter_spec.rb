require 'rails_helper'

describe Wallaby::ModelClassFilter do
  describe '#execute' do
    subject do
      described_class.execute(
        all: all,
        whitelisted: whitelisted,
        blacklisted: blacklisted
      )
    end

    let(:all) { [AllPostgresType, AllMysqlType, AllSqliteType] }
    let(:whitelisted) { [] }
    let(:blacklisted) { [] }

    it 'returns all models' do
      expect(subject).to eq [AllPostgresType, AllMysqlType, AllSqliteType]
    end

    context 'when there are excludes' do
      let(:blacklisted) { [AllPostgresType] }

      it 'excludes AllPostgresType' do
        expect(subject).to eq [AllMysqlType, AllSqliteType]
      end

      context 'when models are set' do
        let(:whitelisted) { [AllSqliteType] }

        it 'returns the models being set' do
          expect(subject).to eq [AllSqliteType]
        end

        context 'when some of the models being set are invalid' do
          let(:whitelisted) { [Wallaby, AllSqliteType] }

          it 'raises error' do
            expect { subject }.to raise_error Wallaby::InvalidError
          end
        end
      end
    end

    context 'when models are set' do
      let(:whitelisted) { [AllSqliteType] }

      it 'returns the models being set' do
        expect(subject).to eq [AllSqliteType]
      end

      context 'when some of the models being set are invalid' do
        let(:whitelisted) { [Wallaby, AllSqliteType] }

        it 'raises error' do
          expect { subject }.to raise_error Wallaby::InvalidError
        end
      end

      context 'when there are excludes' do
        let(:blacklisted) { [AllPostgresType] }

        it 'still returns the models being set' do
          expect(subject).to eq [AllSqliteType]
        end
      end
    end
  end
end
