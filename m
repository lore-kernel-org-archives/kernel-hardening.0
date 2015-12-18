Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 18 Dec 2015 04:00:03 +0300
From: Solar Designer <solar@openwall.com>
Message-ID: <20151218010003.GA19179@openwall.com>
References: <CAB-iPKVnu554hZ=nSmSgrLQE+c02oGKE8As5prWHy6n0O=erCw@mail.gmail.com> <CAGXu5j+mTVrtDXbGtF=-nyAxnTe2YDL4PyUnJw+vfXX_ZVzwxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+mTVrtDXbGtF=-nyAxnTe2YDL4PyUnJw+vfXX_ZVzwxg@mail.gmail.com>
Subject: Re: [kernel-hardening] Introduction
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 17, 2015 at 04:36:21PM -0800, Kees Cook wrote:
> On Thu, Dec 17, 2015 at 3:34 PM, Leibowitz, Michael wrote:
> > I'm Interested in working on struct randomization ala RANDSTRUCT.
> > Does this seem like a suitable task?
> 
> I certainly wouldn't turn it down, but I would observe that it has
> some limited utility to users of the kernel that produce binary
> builds. e.g. all the given builds of Ubuntu with RANDSTRUCT would be
> the same (though the next released version would see a different
> randomization, etc).

OTOH, it allows for a randomized-kernel-builds-as-a-service model, which
IIRC is something grsecurity was/is offering.  If the feature is
upstream'ed, perhaps there will be more setups of this sort, including
within a handful of organizations for their own use.

So I am in favor of Michael working on this feature.

> Since there's no hardening tree yet, there's no maintainer, but since
> I'm trying to drive the kernel self-protection project here, I'll
> self-nominate myself as "hardening maintainer", FWIW. ;)

I appreciate your effort on this, Kees!

Alexander
