MIME-Version: 1.0
References: <1536516257-30871-1-git-send-email-s.mesoraca16@gmail.com> <20180909191903.GA2344@ravnborg.org>
In-Reply-To: <20180909191903.GA2344@ravnborg.org>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sun, 16 Sep 2018 19:14:44 +0200
Message-ID: <CAJHCu1++7sJv88Qg4wtx-AhfmQCbjy2psxuoePz2YViLNu-ahA@mail.gmail.com>
Subject: Re: [PATCH v2] kconfig: add hardened defconfig helpers
Content-Type: text/plain; charset="UTF-8"
To: sam@ravnborg.org
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>, corbet@lwn.net, keescook@chromium.org, labbott@redhat.com, yamada.masahiro@socionext.com, michal.lkml@markovi.net, ebiederm@xmission.com
List-ID: <kernel-hardening.lists.openwall.com>

Sam Ravnborg <sam@ravnborg.org> wrote:
>
> Hi Salvatore.

Hi Sam

> On Sun, Sep 09, 2018 at 08:04:17PM +0200, Salvatore Mesoraca wrote:
> > Adds 4 new defconfig helpers (hardenedlowconfig, hardenedmediumconfig,
> > hardenedhighconfig, hardenedextremeconfig) to enable various hardening
> > features.
> > The list of config options to enable is based on KSPP's Recommended
> > Settings and on kconfig-hardened-check, with some modifications.
> > These options are divided into 4 levels (low, medium, high, extreme)
> > based on their negative side effects, not on their usefulness.
> > 'Low' level collects all those protections that have (almost) no
> > negative side effects.
> > 'Extreme' level collects those protections that may have so many
> > negative side effects that most people wouldn't want to enable them.
> > Every feature in each level is briefly documented in
> > Documentation/security/hardenedconfig.rst, this file also contain a
> > better explanation of what every level means.
> > To prevent this file from drifting from what the various defconfigs
> > actually do, it is used to dynamically generate the config fragments.
>
> In the above you nicely describes what is done.
> But there is nothing about the target group for this feature.
> Who will benefit from this?

Sometimes people ask about kernel hardening features, that's the
reason why the KSPP's list and the kconfig-hardened-check script were
written.
Unfortunately, kernel features with security implications have often
misleading names and descriptions and are scattered around the
menuconfig.
This patchset will help anyone who want to have an "hardened kernel"
but isn't following kernel development closely enough to know about
all the features.
On one hand, this will provide an official and understandable list of
hardening features inside the kernel doc, on the other hand it also
provide a fast and easy way to enable those features all at once.

> With respect to the actual implmentation we now
> have two ways to handle config fragments.
> Current solution is to save the config fragments in kernel/configs.
> And the new solution is to parse the config fragments from an rst file.
> The changelog fails to mentions why we need a new way to handle
> the config fragments.

The reason why I'm doing it like this is that I want both the config
fragments and the doc in the kernel.
Generating the fragments from the doc is the best way to make sure
that they will always do what the doc says.

> If we want to go the "parse from rst file" way - can it then
> be abstracted in a way so this is the only way to handle
> these in-kernel config fragments?
> And then move the current config fragment to the new way.
>
> It most be possible with a little careful design to make this
> a general solution and not a hardening thing only.

I don't know if maintainers of the other fragments care at all about
having every single option documented in detail.
For hardening features it makes sense, because people may want to just
learn about them and enable them manually.
I don't know if this is common or desirable for other config fragments.

Thank you for you comment,

Salvatore
