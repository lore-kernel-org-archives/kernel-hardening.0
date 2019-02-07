From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH 0/3] Minor bug fixes to leaking_addresses.pl
Date: Fri,  8 Feb 2019 09:50:23 +1100
Message-Id: <20190207225026.11723-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <tobin@kernel.org>, Tycho Andersen <tycho@tycho.ws>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Here are a few minor fixes/improvements to scripts/leaking_addresses.pl

Patch 1: Fixes places where I don't know how to Perl.

Patch 2: Removes `--version` command line option, completely this time.

Patch 3: Fix a bug in the command line options parsing.

thanks,
Tobin.


Tobin C. Harding (3):
  leaking_addresses: Fix calls to dprint
  leaking_addresses: Completely remove --version flag
  leaking_addresses: Expand tilde in output file name

 scripts/leaking_addresses.pl | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

-- 
2.20.1
