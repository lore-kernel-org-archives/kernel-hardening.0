Return-Path: <kernel-hardening-return-21546-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id B382CC433EF
	for <kernel-hardening@archiver.kernel.org>; Sun,  6 Feb 2022 13:48:11 +0000 (UTC)
Received: (qmail 1688 invoked by uid 550); 6 Feb 2022 13:48:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1653 invoked from network); 6 Feb 2022 13:48:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1644155267;
	bh=LZnVpND4TW3EHGCa7Bt7E3If2oojjj22Tn2/52XBPWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E1qW8ITUFwf/4dD8xfL6W4dli7he4xICS2fT/MdB/6tJEcaA70T/dYcYtwDTnq2uk
	 oAXe6wB6eF86RKy5yWv+qSeCmNmZmOZHDRoTlhjpUPKE5m87Bhqfdm0rfdmjUYls2T
	 B79dM9UwHBqXG67B+euhaPL8jtPv3VCbdOUDMArafxSz9yNecXuB7P59vwEcCOe+Q0
	 doHGn8ocBdGFwZJhaVUz29Owl0WzhS5Snt3AI2izgjlTQg/6t/kTdfwV/8tHN0UYVx
	 kcSRny6koAdIsxsRYumo6sL+/F4Gwhs5hYEVW0rbERA5tN9W/JS7e/whyiGhdSZ5vT
	 2+VPkEHMYtT9Q==
Date: Sun, 6 Feb 2022 14:47:41 +0100
From: Christian Brauner <brauner@kernel.org>
To: "Anton V. Boyarshinov" <boyarsh@altlinux.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
	ebiederm@xmission.com, legion@kernel.org, ldv@altlinux.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	Christoph Hellwig <hch@lst.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Add ability to disallow idmapped mounts
Message-ID: <20220206134741.ze3e4ndzxrckdiz5@wittgenstein>
References: <20220204065338.251469-1-boyarsh@altlinux.org>
 <20220204094515.6vvxhzcyemvrb2yy@wittgenstein>
 <20220204132616.28de9c4a@tower>
 <20220204151032.7q22hgzcil4hqvkl@wittgenstein>
 <20220205105758.1623e78d@tower>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220205105758.1623e78d@tower>

On Sat, Feb 05, 2022 at 10:57:58AM +0300, Anton V. Boyarshinov wrote:
> В Fri, 4 Feb 2022 16:10:32 +0100
> Christian Brauner <brauner@kernel.org> пишет:
> 
> 
> > > It turns off much more than idmapped mounts only. More fine grained
> > > control seems better for me.  
> > 
> > If you allow user namespaces and not idmapped mounts you haven't reduced
> > your attack surface.
> 
> I have. And many other people have. People who have creating user
> namespaces by unpriviliged user disabled. I find it sad that we have no
> tool in mainline kernel to limit users access to creating user
> namespaces except complete disabling them. But many distros have that
> tools. Different tools with different interfaces and semantics :(
> 
> And at least one major GNU/Linux distro disabled idmapped mounts
> unconditionally. If I were the author of this functionality, I would
> prefer to have a knob then have it unavailible for for so many users. But as you wish.
 
You're talking about the author of the allegations being involved in
disabling idmapped mounts for rhel under [2] as I was told.
 
If a downstream distro wants to disable this feature based on
allegations we've refuted multiple times then we can't stop them from
doing so.

The only disconcerting thing is that this helps spreads misinformation
as evidenced by this patch. The allegations and refutation around them
are all visible and I've linked to them in the initial reply.

This is a root-only accessible feature with a massive testsuite and
being used for 2 years. Each bug fixed gets its own regression test
right away. We will of course take and upstream patches that fix actual
clearly reported bugs.
 
In the end it is not different from say Archlinux [1] having had user
namespaces disabled for 5+ years from their introduction in 2013
onwards and many other examples. Downstream distros can make whatever
choice they want and diverge from upstream.
 
In any case, I'll be on vacation for about 2 weeks with very limited
access to internet going forward.
 
[1]: https://bugs.archlinux.org/task/36969
[2]: https://gitlab.com/redhat/centos-stream/src/kernel/centos-stream-9/-/merge_requests/131

> 
> > An unprivileged user can reach much more
> > exploitable code simply via unshare -user --map-root -mount which we
> > still allow upstream without a second thought even with all the past and
> > present exploits (see
> > https://www.openwall.com/lists/oss-security/2022/01/29/1 for a current
> > one from this January).
> > 
> > >   
> > > > They can neither
> > > > be created as an unprivileged user nor can they be created inside user
> > > > namespaces.  
> > > 
> > > But actions of fully privileged user can open non-obvious ways to
> > > privilege escalation.  
> > 
> > A fully privileged user potentially being able to cause issues is really
> > not an argument; especially not for a new sysctl.
> > You need root to create idmapped mounts and you need root to turn off
> > the new knob.
> > 
> > It also trivially applies to a whole slew of even basic kernel tunables
> > basically everything that can be reached by unprivileged users after a
> > privileged user has turned it on or configured it.
> > 
> > After 2 years we haven't seen any issue with this code and while I'm not
> > promising that there won't ever be issues - nobody can do that - the
> > pure suspicion that there could be some is not a justification for
> > anything.
> 
> 
