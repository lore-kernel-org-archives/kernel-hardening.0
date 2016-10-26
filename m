Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BF8D57@IRSMSX102.ger.corp.intel.com>
References: <1476959131-6153-1-git-send-email-elena.reshetova@intel.com>
 <20161020131350.GA18331@thigreal> <CAGXu5jK1MNzM5Qi8o+HHekWm38n-WVPQ1Q3_EPpjYqE0kk8X0w@mail.gmail.com>
 <20161025090559.eqsll3d7y2ifdaug@thigreal> <1477415895.2263.43.camel@cvidal.org>
 <CAEXv5_jk+2KOxL9UdZ5+6B8+JV2CBtNGi65a7ddtvxwUGmnPkA@mail.gmail.com>
 <1477428836.2263.70.camel@cvidal.org> <2236FBA76BA1254E88B949DDB74E612B41BF8C68@IRSMSX102.ger.corp.intel.com>
 <1477471489.2263.107.camel@cvidal.org> <2236FBA76BA1254E88B949DDB74E612B41BF8D57@IRSMSX102.ger.corp.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 26 Oct 2016 12:49:49 -0700
Message-ID: <CAGXu5jLoQY4yg0zfDOiW6MsFQ5xQ9i8GG5sdU2=G69xqEbxL0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC v2 PATCH 00/13] HARDENED_ATOMIC
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Colin Vidal <colin@cvidal.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 26, 2016 at 2:46 AM, Reshetova, Elena
<elena.reshetova@intel.com> wrote:
> So, again for clarity, let's break this case into two cases also:
> (3) CONFIG_GENERIC_ATOMIC64 is set, architecture does not provide any
> atomic64 implementations, CONFIG_ARCH_HARDENED_ATOMIC is set
> (4) CONFIG_GENERIC_ATOMIC64 is set, architecture does not provide any
> atomic64 implementations, CONFIG_ARCH_HARDENED_ATOMIC is unset
>
> The current implementation what we have in the hardened_atomic_on_next
> branch actually treats both of these cases in the same way (this is what
> Hans was explaining before): it does define atomic64*_wrap functions in
> both cases, but they point to the same normal functions. So, no protection
> provided in any case. Based on the current thread it seems that we might
> want to have protection in the case (3) after all, which is not really
> straightforward (maybe that's why grsecurity didn't have support for it).

3 is an interesting combination, and a seemingly strange hole in
PAX_REFCOUNT. The implementation of CONFIG_GENERIC_ATOMIC64 uses
spinlocks, so doing an overflow test would be trivial to add. I was
thinking that this wasn't done under PAX_REFCOUNT because the CONFIG
combination didn't exist, but that seems false:

config ARM
        ...
        select GENERIC_ATOMIC64 if (CPU_V7M || CPU_V6 || !CPU_32v6K || !AEABI)

config PAX_REFCOUNT
        ...
        depends on GRKERNSEC && ((ARM && (CPU_V6 || CPU_V6K ||
CPU_V7)) || MIPS || PPC || SPARC64 || X86)

The ARM && CPU_V6 case is explicitly covered by PAX_REFCOUNT, but
AFACIT, doesn't protect atomic64.

> Also, what's why we first wanted to know how common this case (3)
> would be in practice? Should we just merge first the common cases and
> for example as Colin was proposing make it impossible for now to select
> CONFIG_HARDENED_ATOMIC for the case (3)? Actually I believe it is not
> even really possible to select it now in this case, or am I wrong? IMO
> we don't have anything providing CONFIG_ARCH_HARDENED_ATOMIC in this case.

I think a fine first step would be to have CONFIG_HARDENED_ATOMIC
depend on !GENERIC_ATOMIC64 for now. When HARDENED_ATOMIC is expanded
to include other architectures that use GENERIC_ATOMIC64, it can be
added then. (Which maybe Colin would be interested in doing for ARM
CPU_V6.)

-Kees

-- 
Kees Cook
Nexus Security
