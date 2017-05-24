From: riel@redhat.com
Date: Wed, 24 May 2017 11:57:46 -0400
Message-Id: <20170524155751.424-1-riel@redhat.com>
Subject: [kernel-hardening] [PATCH v2 0/5] stackprotector: ascii armor the stack canary
To: linux-kernel@vger.kernel.org
Cc: danielmicay@gmail.com, tytso@mit.edu, keescook@chromium.org, hpa@zytor.com, luto@amacapital.net, mingo@kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, linux-sh@vger.kernel.org, ysato@users.sourceforge.jp, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Zero out the first byte of the stack canary value on 64 bit systems,
in order to mitigate unterminated C string overflows.

The null byte both prevents C string functions from reading the
canary, and from writing it if the canary value were guessed or
obtained through some other means.
    
Reducing the entropy by 8 bits is acceptable on 64-bit systems,
which will still have 56 bits of entropy left, but not on 32
bit systems, so the "ascii armor" canary is only implemented on
64-bit systems.

Inspired by the "ascii armor" code in execshield and Daniel Micay's
linux-hardened tree.

Also see https://github.com/thestinger/linux-hardened/

v2:
 - improve changelogs
 - address Ingo's coding style comments
