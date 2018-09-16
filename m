MIME-Version: 1.0
References: <1536516257-30871-1-git-send-email-s.mesoraca16@gmail.com>
 <20180909191903.GA2344@ravnborg.org> <CAK7LNATP_3K0KYyW51K3mqHs-WiReJWMeB82Uxikh+zUqDKQ6A@mail.gmail.com>
In-Reply-To: <CAK7LNATP_3K0KYyW51K3mqHs-WiReJWMeB82Uxikh+zUqDKQ6A@mail.gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sun, 16 Sep 2018 19:44:09 +0200
Message-ID: <CAJHCu1JtS2nTaxCbSDOvUYZe2Lf2LpcOvhBE00vX6XiFEH_hZg@mail.gmail.com>
Subject: Re: [PATCH v2] kconfig: add hardened defconfig helpers
Content-Type: text/plain; charset="UTF-8"
To: yamada.masahiro@socionext.com
Cc: sam@ravnborg.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>, corbet@lwn.net, keescook@chromium.org, labbott@redhat.com, michal.lkml@markovi.net, ebiederm@xmission.com
List-ID: <kernel-hardening.lists.openwall.com>

Masahiro Yamada <yamada.masahiro@socionext.com> wrote:
>
> 2018-09-10 4:19 GMT+09:00 Sam Ravnborg <sam@ravnborg.org>:
> > Hi Salvatore.
> >
> > On Sun, Sep 09, 2018 at 08:04:17PM +0200, Salvatore Mesoraca wrote:
> >> Adds 4 new defconfig helpers (hardenedlowconfig, hardenedmediumconfig,
> >> hardenedhighconfig, hardenedextremeconfig) to enable various hardening
> >> features.
> >> The list of config options to enable is based on KSPP's Recommended
> >> Settings and on kconfig-hardened-check, with some modifications.
> >> These options are divided into 4 levels (low, medium, high, extreme)
> >> based on their negative side effects, not on their usefulness.
> >> 'Low' level collects all those protections that have (almost) no
> >> negative side effects.
> >> 'Extreme' level collects those protections that may have so many
> >> negative side effects that most people wouldn't want to enable them.
> >> Every feature in each level is briefly documented in
> >> Documentation/security/hardenedconfig.rst, this file also contain a
> >> better explanation of what every level means.
> >> To prevent this file from drifting from what the various defconfigs
> >> actually do, it is used to dynamically generate the config fragments.
> >
> > In the above you nicely describes what is done.
> > But there is nothing about the target group for this feature.
> > Who will benefit from this?
> >
> > With respect to the actual implmentation we now
> > have two ways to handle config fragments.
> > Current solution is to save the config fragments in kernel/configs.
> > And the new solution is to parse the config fragments from an rst file.
> > The changelog fails to mentions why we need a new way to handle
> > the config fragments.
>
>
> I agree.
>
> Another new way this patch added is,
>
>  CONFIG options are now described in the ReST document,
>  but our current way is to describe the detailed information
>  in the 'help' section in Kconfig files.

This is true, but hardening features are quite different from other
types of features or config options, because they can't be easily
found, unless you already know what you are looking for.
Many people need a single place that lists them all, clearly
explaining why they might want them or not without having to bounce
around different Kconfig parts.

Thank you for your time,

Salvatore
