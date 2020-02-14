require 'rails_helper'
require 'parslet/rig/rspec'

describe Wallaby::Parser do
  it 'parses a very complicated statement' do
    expect(subject.parse('"quoted key" nil null "" "nil" 123.45 "123.45" true "true" false "false" field1:!key1,key2,key3,true field2:>key21 field3:<>nil,123.45,true,false,"nil","true" fuzzy query "all good"')).to eq(
      [
        { string: 'quoted key' },
        { null: 'nil' },
        { null: 'null' },
        { string: [] },
        { string: 'nil' },
        { number: '123.45' },
        { string: '123.45' },
        { boolean: 'true' },
        { string: 'true' },
        { boolean: 'false' },
        { string: 'false' },
        { left: 'field1', op: ':!', right: [
          { string: 'key1' },
          { string: 'key2' },
          { string: 'key3' },
          { boolean: 'true' }
        ] },
        { left: 'field2', op: ':>', right: { string: 'key21' } },
        { left: 'field3', op: ':<>', right: [
          { null: 'nil' },
          { number: '123.45' },
          { boolean: 'true' },
          { boolean: 'false' },
          { string: 'nil' },
          { string: 'true' }
        ] },
        { string: 'fuzzy' },
        { string: 'query' },
        { string: 'all good' }
      ]
    )
  end

  describe 'colon_query' do
    it 'parses colon_query' do
      expect(subject.colon_query.parse('field:fuzzy')).to eq(left: 'field', op: ':', right: { string: 'fuzzy' })
      expect(subject.colon_query.parse('field:"fuzzy search"')).to eq(left: 'field', op: ':', right: { string: 'fuzzy search' })
      expect(subject.colon_query.parse('field:"fuzzy search",extra')).to eq(left: 'field', op: ':', right: [{ string: 'fuzzy search' }, { string: 'extra' }])
      expect(subject.colon_query.parse('field:"fuzzy search",extra,"something else"')).to eq(left: 'field', op: ':', right: [{ string: 'fuzzy search' }, { string: 'extra' }, { string: 'something else' }])
    end
  end

  describe 'name' do
    it 'parses name' do
      expect(subject.name).to parse('name')
      expect(subject.name).not_to parse(' :name')
      expect(subject.name).not_to parse('name ')
      expect(subject.name).not_to parse('name:')
    end
  end

  describe 'operator' do
    it 'parses operator' do
      expect(subject.operator).to parse(':')
      expect(subject.operator).to parse(':!')
      expect(subject.operator).to parse(':<>')
      expect(subject.operator).not_to parse(':<: ')
      expect(subject.operator).not_to parse(':"')
      expect(subject.operator).not_to parse(': ')
      expect(subject.operator).not_to parse(':0')
      expect(subject.operator).not_to parse(':a')
    end
  end

  describe 'keywords' do
    it 'parses keywords' do
      expect(subject.keywords.parse('a,b,c')).to eq([{ string: 'a' }, { string: 'b' }, { string: 'c' }])
      expect(subject.keywords.parse('a')).to eq(string: 'a')
      expect(subject.keywords.parse('"a b",z,x')).to eq([{ string: 'a b' }, { string: 'z' }, { string: 'x' }])
      expect(subject.keywords.parse('z,x,"a b"')).to eq([{ string: 'z' }, { string: 'x' }, { string: 'a b' }])
      expect(subject.keywords.parse('"a b"')).to eq(string: 'a b')
      expect(subject.keywords.parse('""')).to eq(string: [])
      expect(subject.keywords.parse('"')).to eq(string: '"')
    end
  end

  describe 'quoted_keyword' do
    it 'parses quoted_keyword' do
      expect(subject.quoted_keyword.parse('"something"')).to eq(string: 'something')
      expect(subject.quoted_keyword.parse("'something'")).to eq(string: 'something')
      expect(subject.quoted_keyword).not_to parse("something'")
    end
  end

  describe 'keyword' do
    it 'parses keyword' do
      expect(subject.keyword).to parse('something')
      expect(subject.keyword).not_to parse(' something')
      expect(subject.keyword).not_to parse(',something')
    end
  end

  describe 'number' do
    it 'parses number' do
      expect(subject.number).to parse('3.14')
      expect(subject.number).to parse('314')
      expect(subject.number).not_to parse('3..14')
      expect(subject.number).not_to parse('.14')
    end
  end

  describe 'null' do
    it 'parses null' do
      expect(subject.null).to parse('nil')
      expect(subject.null).to parse('nIl')
      expect(subject.null).to parse('null')
      expect(subject.null).to parse('nUlL')

      expect(subject.null).not_to parse('empty')
    end
  end

  describe 'boolean' do
    it 'parses boolean' do
      expect(subject.boolean).to parse('true')
      expect(subject.boolean).to parse('tRue')
      expect(subject.boolean).to parse('True')
      expect(subject.boolean).to parse('false')
      expect(subject.boolean).to parse('faLse')
      expect(subject.boolean).to parse('False')

      expect(subject.boolean).not_to parse('Yes')
      expect(subject.boolean).not_to parse('No')
      expect(subject.boolean).not_to parse('0')
      expect(subject.boolean).not_to parse('1')
      expect(subject.boolean).not_to parse('2')
    end
  end

  describe 'digits' do
    it 'parses digits' do
      expect(subject.digits.parse('0123456789')).to eq('0123456789')
    end
  end

  describe 'dot' do
    it 'parses dot' do
      expect(subject.dot.parse('.')).to eq('.')
    end
  end

  describe 'comma' do
    it 'parses comma' do
      expect(subject.comma.parse(',')).to eq(',')
    end
  end

  describe 'spaces' do
    it 'parses spaces' do
      expect(subject.spaces.parse(' ')).to eq(' ')
      expect(subject.spaces.parse('  ')).to eq('  ')
      expect(subject.spaces.parse("\n")).to eq("\n")
      expect(subject.spaces.parse("\n\n")).to eq("\n\n")
    end
  end

  describe 'colon' do
    it 'parses colon' do
      expect(subject.colon.parse(':')).to eq(':')
    end
  end

  describe 'open_quote' do
    it 'parses open_quote' do
      expect(subject.open_quote.parse('"')).to eq('"')
      expect(subject.open_quote.parse("'")).to eq("'")
    end
  end
end
