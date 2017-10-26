From: Mark Rutland <mark.rutland@arm.com>
Date: Thu, 26 Oct 2017 10:09:40 +0100
Message-Id: <20171026090942.7041-1-mark.rutland@arm.com>
Subject: [kernel-hardening] [RFC PATCH 0/2] arm64: optional paranoid __{get,put}_user checks
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Will Deacon <will.deacon@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

In Prague, Kees mentioned that it would be nice to have a mechanism to
catch bad __{get,put}_user uses, such as the recent CVE-2017-5123 [1,2]
issue with unsafe_put_user() in waitid().

These patches allow an optional access_ok() check to be dropped in
arm64's __{get,put}_user() primitives. These will then BUG() if a bad
user pointer is passed (which should only happen in the absence of an
earlier access_ok() check).

The first patch rewrites the arm64 access_ok() check in C. This gives
the compiler the visibility it needs to elide redundant access_ok()
checks, so in the common case:

  get_user()
    access_ok()
    __get_user()
      BUG_ON(!access_ok())
      <uaccess asm>

... the compiler can determine that the second access_ok() must return
true, and can elide it along with the BUG_ON(), leaving:

  get_user()
    access_ok()
      __get_user()
        <uaccess asm>

... and thus this sanity check can have no cost in the common case.

The compiler doesn't always have the visibility to do this (e.g. if the
two access_ok() checks are in different compilation units), but it seems
to manage to do this most of the time -- In testing with v4.14-rc5
defconfig this only increases the total Image size by 4KiB.

I had a go at turning this into a BUILD_BUG_ON(), to see if we could
catch this issue at compile time. However, my GCC wasn't able to remove
the BUILD_BUG() from some {get,put}_user cases. Maybe we can fix that,
or maybe we can have some static analysis catch this at build time.

It's entirely possible that I've made some catastrophic mistake in these
patches; I've only build-tested them so far, and I don't currently have
access to hardware to test on.

I also haven't yet modified __copy_{to,from}_user and friends along
similar lines, so this is incomplete. If there aren't any major
objections to this approach, I can fold those in for the next spin.

Thanks,
Mark.

[1] https://lwn.net/Articles/736348/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=96ca579a1ecc943b75beba58bebb0356f6cc4b51


Mark Rutland (2):
  arm64: write __range_ok() in C
  arm64: allow paranoid __{get,put}user

 arch/arm64/Kconfig               |  9 +++++++++
 arch/arm64/include/asm/uaccess.h | 27 +++++++++++++++++++--------
 2 files changed, 28 insertions(+), 8 deletions(-)

-- 
2.11.0
