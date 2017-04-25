Message-ID: <1493081807.21623.7.camel@gmail.com>
From: Balbir Singh <bsingharora@gmail.com>
Date: Tue, 25 Apr 2017 10:56:47 +1000
In-Reply-To: <8737cxswuk.fsf@concordia.ellerman.id.au>
References: <1492698980-19510-1-git-send-email-mpe@ellerman.id.au>
	 <1492995750.2418.4.camel@gmail.com>
	 <8737cxswuk.fsf@concordia.ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v2] powerpc/mm: Add support for
 runtime configuration of ASLR limits
To: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@ozlabs.org
Cc: bhsharma@redhat.com, keescook@chromium.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2017-04-25 at 00:29 +1000, Michael Ellerman wrote:
> Balbir Singh <bsingharora@gmail.com> writes:
> 
> > On Fri, 2017-04-21 at 00:36 +1000, Michael Ellerman wrote:
> > > Add powerpc support for mmap_rnd_bits and mmap_rnd_compat_bits, which are two
> > > sysctls that allow a user to configure the number of bits of randomness used for
> > > ASLR.
> 
> ...
> > 
> > Could we please suggest that this should not be sent to stable or back-ported
> > as the 128T default is new?
> 
> I'm not sure I follow. I didn't tag it for stable. Do you mean we should
> explicitly mark it as not-for-stable?
> 

Yeah.. I am concerned someone might backport it without looking at
the dependencies :)

> If someone sends it to stable@vger I'll be pinged before it goes in and
> nak it, if someone wants to backport it (incorrectly) to their own tree
> then good luck to them :)

Fair enough

<snip>

> > > +	rnd = get_random_long() % (1 << shift);
> > 
> > Nitpick, 1 should be 1UL?
> 
> No, shift can only be 29 at most IIRC?
> 
> But it's a bit fragile, so I'll change it.
> 
> cheers

Cheers and I agree with Kees, a lot of the arch_mmap_rnd() code is beginning
to look similar :)

Balbir Singh
