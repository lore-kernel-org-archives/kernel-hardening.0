Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1476959131-6153-2-git-send-email-elena.reshetova@intel.com>
References: <1476959131-6153-1-git-send-email-elena.reshetova@intel.com> <1476959131-6153-2-git-send-email-elena.reshetova@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 24 Oct 2016 16:04:58 -0700
Message-ID: <CAGXu5jJKa=dRX403On4iCLyNdjW6evT7TWAJCxMvV+qRJPYjag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v2 PATCH 01/13] Add architecture independent hardened atomic base
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 20, 2016 at 3:25 AM, Elena Reshetova
<elena.reshetova@intel.com> wrote:
> This series brings the PaX/Grsecurity PAX_REFCOUNT [1]
> feature support to the upstream kernel. All credit for the
> feature goes to the feature authors.
>
> The name of the upstream feature is HARDENED_ATOMIC
> and it is configured using CONFIG_HARDENED_ATOMIC and
> HAVE_ARCH_HARDENED_ATOMIC.
>
> This series only adds x86 support; other architectures are expected
> to add similar support gradually.
> [...]
> Bugs Prevented
> --------------
> HARDENED_ATOMIC would directly mitigate these Linux kernel bugs:
>
> CVE-2016-3135 - Netfilter xt_alloc_table_info integer overflow
> CVE-2010-2959 - CAN integer overflow vulnerability,
> related post: https://jon.oberheide.org/blog/2010/09/10/linux-kernel-can-slub-overflow/

These CVEs are "regular" integer overflows, rather than ref-counting
flaws, so they should be left off the example list. (On kernsec.org,
ref counting is a sub-set of integer overflow flaws, but the exploit
examples are all merged together; Sorry for the confusion!)

> CVE-2016-0728 - Keyring refcount overflow

Exploit link is https://www.exploit-db.com/exploits/39277/

> CVE-2014-2851 - Group_info refcount overflow

Exploit link is https://www.exploit-db.com/exploits/32926/

>
> And a relatively fresh exploit example:
> https://www.exploit-db.com/exploits/39773/

For completeness, this is CVE-2016-4558.

> [...]
>  Documentation/security/hardened-atomic.txt | 141 +++++++++++++++

Nit on whitespace: I get warnings from git about trailing whitespace
in this file.

-Kees

-- 
Kees Cook
Nexus Security
