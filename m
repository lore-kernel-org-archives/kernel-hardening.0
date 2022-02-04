Return-Path: <kernel-hardening-return-21543-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 90AEAC433EF
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Feb 2022 15:15:03 +0000 (UTC)
Received: (qmail 3399 invoked by uid 550); 4 Feb 2022 15:14:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1588 invoked from network); 4 Feb 2022 15:10:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1643987437;
	bh=IoHPIjb2fSbuPpgienLeVPvvwcFaWSnzgKep7XPLsnU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ken7aeQ6msksQh20Q4C97KzBOyXJUMa4ehlX3O/QpWCWC6BHgF9TJh5WQ8fdyrw/3
	 sPUmwlDb3+mpdoW/Qa3jsqNy81CByFyrjJ8Oy7GWKMEtI9dL2toPVHJ4cy91EUTo3s
	 i9o42Z4PFuIv+6NP1f0PpbYh6cb972MZTbFmzPXo9oDErQLYa+z5ankmAaGMSW6kjI
	 Kh5hlnIn+yw4AUy2igK5C1deGnWkqu9GStd/IyzLw5r2j1mE3fvRzg860jmoDFRRfW
	 okQj8KkUXQ8+wkbqJ56hgIN0H9xeXuaxw7MuLHEuS1Ou0eeGeV/8GQdrcp0vBWRhf6
	 fQ1JDsnXrrCcQ==
Date: Fri, 4 Feb 2022 16:10:32 +0100
From: Christian Brauner <brauner@kernel.org>
To: "Anton V. Boyarshinov" <boyarsh@altlinux.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
	ebiederm@xmission.com, legion@kernel.org, ldv@altlinux.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	Christoph Hellwig <hch@lst.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Add ability to disallow idmapped mounts
Message-ID: <20220204151032.7q22hgzcil4hqvkl@wittgenstein>
References: <20220204065338.251469-1-boyarsh@altlinux.org>
 <20220204094515.6vvxhzcyemvrb2yy@wittgenstein>
 <20220204132616.28de9c4a@tower>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220204132616.28de9c4a@tower>

On Fri, Feb 04, 2022 at 01:26:16PM +0300, Anton V. Boyarshinov wrote:
> В Fri, 4 Feb 2022 10:45:15 +0100
> Christian Brauner <brauner@kernel.org> пишет:
> 
> > If you want to turn off idmapped mounts you can already do so today via:
> > echo 0 > /proc/sys/user/max_user_namespaces
> 
> It turns off much more than idmapped mounts only. More fine grained
> control seems better for me.

If you allow user namespaces and not idmapped mounts you haven't reduced
your attack surface. An unprivileged user can reach much more
exploitable code simply via unshare -user --map-root -mount which we
still allow upstream without a second thought even with all the past and
present exploits (see
https://www.openwall.com/lists/oss-security/2022/01/29/1 for a current
one from this January).

> 
> > They can neither
> > be created as an unprivileged user nor can they be created inside user
> > namespaces.
> 
> But actions of fully privileged user can open non-obvious ways to
> privilege escalation.

A fully privileged user potentially being able to cause issues is really
not an argument; especially not for a new sysctl.
You need root to create idmapped mounts and you need root to turn off
the new knob.

It also trivially applies to a whole slew of even basic kernel tunables
basically everything that can be reached by unprivileged users after a
privileged user has turned it on or configured it.

After 2 years we haven't seen any issue with this code and while I'm not
promising that there won't ever be issues - nobody can do that - the
pure suspicion that there could be some is not a justification for
anything.
