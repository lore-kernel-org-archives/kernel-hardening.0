Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 7 Apr 2016 02:05:43 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160407000543.GA26824@gmail.com>
References: <20160406194404.GA11150@www.outflux.net>
 <CAJZ5v0ieAd3WSiytzcdtD=eueLPk_SM1KgrqZXHBa6+bwK=KnQ@mail.gmail.com>
 <20160406215638.GA25539@gmail.com>
 <CAJZ5v0ir8PwyC2b1R0DaE+O5dH0cZUtrzTHxM4OAPxMY9hmNXA@mail.gmail.com>
 <CAGXu5jJQBEivvcGnK4jB+5sbUpx9Sn+RieChXEgU-4ch9=1chA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJQBEivvcGnK4jB+5sbUpx9Sn+RieChXEgU-4ch9=1chA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] Prefer kASLR over Hibernation
To: Kees Cook <keescook@chromium.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Yves-Alexis Perez <corsac@debian.org>, Emrah Demir <ed@abdsec.com>, Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org" <x86@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> >> I don't think this is a good idea, as it turns off emergency hibernation of 
> >> laptops - many desktop distros support it by default.
> >
> > Right, I forgot about this one.
> 
> When I last checked Ubuntu doesn't enable hibernation by default any more: 
> https://help.ubuntu.com/16.04/ubuntu-help/power-hibernate.html
> 
> And it seems like Fedora either doesn't either, or has a lot of people
> for whom it doesn't work:
> https://bugzilla.redhat.com/show_bug.cgi?id=1206936
> https://bugzilla.redhat.com/show_bug.cgi?id=1224151
> http://blog.kriptonium.com/2015/12/fedora-23-hibernate.html

Ok, that's a relatively recent development, I distinctly remember my laptop being 
hibernated in such a fashion fairly recently.

That makes it easier to hack around the kASLR incompatibility by making 
hibernation less useful. Personally I think that conceptually user space 
persistency (CRIU et al) is superior to kernel level hibernation - but
user-space save/restore is nowhere near as complete as kernel hibernation,
so it's still somewhat sad that it doesn't work ...

Thanks,

	Ingo
