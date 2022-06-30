# frozen_string_literal: true

RSpec.describe Mitwelt do
  it "has a version number" do
    expect(Mitwelt::VERSION).not_to be nil
  end

  describe ".fetch" do
    def set_env(key, value)
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with(key) { value }
    end

    context "for timestamps" do
      def timestamp
        "2020-01-01T00:00:00Z"
      end

      it "parses the timestamp" do
        set_env("time", timestamp)
        expect(described_class.fetch("time", type: :timestamp)).to eq(Time.parse(timestamp))
      end

      context "if the ENV var is not set" do
        context "if required" do
          it "raises an error" do
            expect { described_class.fetch("time", type: :timestamp, required: true) }.to raise_error(described_class::Error)
          end

          context "with a default" do
            it "returns the default" do
              time = Time.now
              expect(described_class.fetch("time", type: :timestamp, required: true, default: time)).to eq(time)
            end
          end

          context "if the default is of the wrong type" do
            it "raises an error" do
              time = "foobar"
              expect { described_class.fetch("time", type: :timestamp, required: true, default: time) }.to raise_error(described_class::Error)
            end
          end
        end

        context "if not required" do
          it "returns nil" do
            expect(described_class.fetch("time", type: :timestamp)).to be_nil
          end
        end
      end
    end

    context "for booleans" do
      it "parses true" do
        set_env("foo", "true")
        expect(described_class.fetch("foo", type: :boolean)).to eq(true)
      end

      it "parses false" do
        set_env("foo", "false")
        expect(described_class.fetch("foo", type: :boolean)).to eq(false)
      end

      it "parses 1 as true" do
        set_env("foo", "1")
        expect(described_class.fetch("foo", type: :boolean)).to eq(true)
      end

      it "parses 0 as false" do
        set_env("foo", "0")
        expect(described_class.fetch("foo", type: :boolean)).to eq(false)
      end

      context "if the ENV var is not set" do
        context "if required" do
          it "raises an error" do
            expect { described_class.fetch("time", type: :timestamp, required: true) }.to raise_error(described_class::Error)
          end

          context "with a default" do
            it "returns the default" do
              time = Time.now
              expect(described_class.fetch("time", type: :timestamp, required: true, default: time)).to eq(time)
            end
          end

          context "if the default is of the wrong type" do
            it "raises an error" do
              time = "foobar"
              expect { described_class.fetch("time", type: :timestamp, required: true, default: time) }.to raise_error(described_class::Error)
            end
          end
        end

        context "if not required" do
          it "returns nil" do
            expect(described_class.fetch("time", type: :timestamp)).to be_nil
          end
        end
      end
    end
  end
end
