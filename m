From: Yann Droneaud <ydroneaud@opteya.com>
Date: Thu, 13 Jun 2019 13:26:03 +0200
Message-Id: <cover.1560423331.git.ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 0/3] ELF interpretor info: align and add random padding
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Yann Droneaud <ydroneaud@opteya.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

The following patches are mostly focused on ensuring AT_RANDOM array is
aligned on 16bytes boundary, and while being located at a pseudo-random
offset on stack (at most 256 bytes).

This patchset also insert a random sized (at most 15 bytes) padding between
AT_RANDOM and AT_PLATFORM and/or AT_BASE_PLATFORM.

It also insert a random sized padding (at most 256 bytes) between those
data and the arrays passed to userspace (argv[] + environ[] + auxv[])
as defined by ABI.

Adding random padding around AT_RANDOM, AT_PLATFORM, AT_BASE_PLATEFORM
should be viewed as an exercise of cargo-cult security as I'm not aware
of any attack that can be prevented with this mechanism in place.

Regards.

Yann Droneaud (3):
  binfmt/elf: use functions for stack manipulation
  binfmt/elf: align AT_RANDOM array
  binfmt/elf: randomize padding between ELF interp info

 fs/binfmt_elf.c | 110 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 86 insertions(+), 24 deletions(-)

-- 
2.21.0
