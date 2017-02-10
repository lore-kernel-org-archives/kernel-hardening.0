From: "Roberts, William C" <william.c.roberts@intel.com>
Date: Fri, 10 Feb 2017 19:02:42 +0000
Message-ID: <476DC76E7D1DF2438D32BFADF679FC562305B2AC@ORSMSX103.amr.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] %pK continuation
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

I haven't had time to really work on the continuation of:
http://www.openwall.com/lists/kernel-hardening/2016/10/07/1

I think the simple approach of killing %p based on kptr_restrict remains th=
e simplest, IMHO best way to achieve a better level of
preventing leaks of kernel addresses. In example of %pK going wrong can be =
found here:
 https://googleprojectzero.blogspot.com/2017/02/lifting-hyper-visor-bypassi=
ng-samsungs.html.

Granted, the exploit author would have found another way to defeat KASL, I'=
d like to force their hand.

In a nut shell, the driver use %pk instead of %pK (capitalization of K matt=
ers).  This would actually be a
good checkpatch.pl check. I grep'd the kernel for %pk (lower case k) and fo=
und no usages!

Just passing along some thoughts,
Bill
