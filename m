From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu,  7 Dec 2017 15:32:20 +1100
Message-Id: <1512621145-4783-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 0/5] leaking_addresses: support 5 page table level
To: me@tobin.cc, kaiwan.billimoria@gmail.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Alexander Kapshuk <alexander.kapshuk@gmail.com>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This set adds support for 5 page table levels on x86_64.

Patch 1 and 2 are clean up.

Patch 3 adds checking vsyscall memory region instead of just first and
last address.

Patch 4 adds support for locating and parsing the current kernel config
file.  It feels like this may be re-inventing the wheel (also the
implementation is not as thorough as scripts/extract-ikconfig?) Much of
the code for this has been posted on LKML a few times now by Kaiwan
Billimoria. As such, it uses the new Co-Developed-by tag.

Patch 5 adds the 5 page table levels stuff. It is trivial once we have a
value from CONFIG_PGTABLE_LEVELS. Just set the regular expression
accordingly.

Perl tips, and code style tips in general, most appreciated.

As usual, any kernel development protocol tips also most
appreciated. Both Kaiwan and myself are pretty new around here, feel
free to give us a kick if we need it.

thanks,
Tobin.

Tobin C. Harding (5):
  leaking_addresses: remove command examples
  leaking_addresses: indent dependant options
  leaking_addresses: add range check for vsyscall memory
  leaking_addresses: add support for kernel config file
  leaking_addresses: add support for 5 page table levels

 scripts/leaking_addresses.pl | 169 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 137 insertions(+), 32 deletions(-)

-- 
2.7.4
