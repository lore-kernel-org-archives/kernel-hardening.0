Date: Sun, 9 Sep 2018 21:19:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2] kconfig: add hardened defconfig helpers
Message-ID: <20180909191903.GA2344@ravnborg.org>
References: <1536516257-30871-1-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1536516257-30871-1-git-send-email-s.mesoraca16@gmail.com>
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: kernel-hardening@lists.openwall.com, linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Salvatore.

On Sun, Sep 09, 2018 at 08:04:17PM +0200, Salvatore Mesoraca wrote:
> Adds 4 new defconfig helpers (hardenedlowconfig, hardenedmediumconfig,
> hardenedhighconfig, hardenedextremeconfig) to enable various hardening
> features.
> The list of config options to enable is based on KSPP's Recommended
> Settings and on kconfig-hardened-check, with some modifications.
> These options are divided into 4 levels (low, medium, high, extreme)
> based on their negative side effects, not on their usefulness.
> 'Low' level collects all those protections that have (almost) no
> negative side effects.
> 'Extreme' level collects those protections that may have so many
> negative side effects that most people wouldn't want to enable them.
> Every feature in each level is briefly documented in
> Documentation/security/hardenedconfig.rst, this file also contain a
> better explanation of what every level means.
> To prevent this file from drifting from what the various defconfigs
> actually do, it is used to dynamically generate the config fragments.

In the above you nicely describes what is done.
But there is nothing about the target group for this feature.
Who will benefit from this?

With respect to the actual implmentation we now
have two ways to handle config fragments.
Current solution is to save the config fragments in kernel/configs.
And the new solution is to parse the config fragments from an rst file.
The changelog fails to mentions why we need a new way to handle
the config fragments.

If we want to go the "parse from rst file" way - can it then
be abstracted in a way so this is the only way to handle
these in-kernel config fragments?
And then move the current config fragment to the new way.

It most be possible with a little careful design to make this
a general solution and not a hardening thing only.

	Sam
