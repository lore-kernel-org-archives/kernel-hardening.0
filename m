Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAB-iPKVnu554hZ=nSmSgrLQE+c02oGKE8As5prWHy6n0O=erCw@mail.gmail.com>
References: <CAB-iPKVnu554hZ=nSmSgrLQE+c02oGKE8As5prWHy6n0O=erCw@mail.gmail.com>
Date: Thu, 17 Dec 2015 16:36:21 -0800
Message-ID: <CAGXu5j+mTVrtDXbGtF=-nyAxnTe2YDL4PyUnJw+vfXX_ZVzwxg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Introduction
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 17, 2015 at 3:34 PM, Leibowitz, Michael
<michael.leibowitz@intel.com> wrote:
> I work in Intel's Open Source Technology center, along with my
> colleague, Elena Reshetova.  I'm reasonably new real-life kernel
> development, having previously just mucked about.  Otherwise, I'm a
> long-time open source/security trouble maker.

Hi! Welcome! :)

> I'm Interested in working on struct randomization ala RANDSTRUCT.
> Does this seem like a suitable task?

I certainly wouldn't turn it down, but I would observe that it has
some limited utility to users of the kernel that produce binary
builds. e.g. all the given builds of Ubuntu with RANDSTRUCT would be
the same (though the next released version would see a different
randomization, etc). It also complicates externally built modules. I
see it depends on HIDESYM, though, which in turn depends on
PAX_USERCOPY, so it would be much weaker without these two finished
first.

All that said, it might still be an interesting piece to extract. It
would make automated cross-distro or cross-version attacks much more
difficult to mount and has in the past exposed some bugs. (e.g.
missing container_of() uses, etc.)

> Also, what is the envisioned working model?  Is there a hardening tree
> to use?  Should we start with sending patches to this list?  Is there
> a hardening maintainer?

I think the most successful workflow for this kind of development is
to first coordinate on the list about what you want to tackle, nail
down what exploits or bug classes it addresses, then extract/create
it, develop tests, post for RFC, get some tuning, and then post it to
upstream for final vetting.

I'd prefer we develop against Linus's latest tree, though using the
prior release or -next is fine. Ultimately, it'll depend on the
maintainer's rebasing desires. Until we have actual dependencies,
there won't be a "hardened tree", though when it does happen, I expect
to be the one to build it from everyone's patch sets. For example, the
__ro_after_init tree lives here:
http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=kspp/postinit-readonly

I think sending patches to the list early is a great idea. If you
don't have tests, we can help write them. If you're still looking for
good exploit examples, we can help hunt them down, etc. It'll let us
all fine-tune it and call out things that need fixing or improvement.
There's going to be a lot of bike-shedding, so best to get our
practice in now. :)

Since there's no hardening tree yet, there's no maintainer, but since
I'm trying to drive the kernel self-protection project here, I'll
self-nominate myself as "hardening maintainer", FWIW. ;)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
