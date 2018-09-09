MIME-Version: 1.0
From: Sandy Harris <sandyinchina@gmail.com>
Date: Sun, 9 Sep 2018 08:22:44 -0400
Message-ID: <CACXcFmki+t-TvaiYxfOyphkF+LRQcJHFQjgW31HrYGRhOCYrEg@mail.gmail.com>
Subject: Checked C?
Content-Type: text/plain; charset="UTF-8"
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Slashdot reports that Microsoft have come up with something they call
"checked C". It claims to prevent a wide variety of memory & pointer
bugs, using a mix of compile-time and run-time checks, at moderate
overheads.

Implementation is as extensions to Clang so it might be hard to apply
to the kernel which I think has some GNU-isms. Perhaps still worth a
look?

Paper describing it is at:
https://www.microsoft.com/en-us/research/publication/checkedc-making-c-safe-by-extension/
Code is at:
https://github.com/Microsoft/checkedc
