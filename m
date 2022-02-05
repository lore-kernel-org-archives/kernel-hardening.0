Return-Path: <kernel-hardening-return-21545-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 6367AC433EF
	for <kernel-hardening@archiver.kernel.org>; Sat,  5 Feb 2022 13:57:59 +0000 (UTC)
Received: (qmail 5654 invoked by uid 550); 5 Feb 2022 13:57:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5622 invoked from network); 5 Feb 2022 13:57:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1644069456;
	bh=4LhrZA/w4th6MUICBQPQhLfKK3MyHiWT60QkciOvN8k=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=vq87wwp1dqa0IZ1lf4KjNnJ6/pUpr4oKlZqHPLZNP09zofZC4abZTNS8bfDmqmoGk
	 vZCQFNNYgXQwUV7CPc7dbsRUJUGJlyhV1NGRFE5yp/HqkvpiZuVA7mKViCSPWxDGWE
	 nETthuPrDofCnOZ3AXzDFAeJO1pcZqEp1xhWqXjY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1644069456;
	bh=4LhrZA/w4th6MUICBQPQhLfKK3MyHiWT60QkciOvN8k=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=vq87wwp1dqa0IZ1lf4KjNnJ6/pUpr4oKlZqHPLZNP09zofZC4abZTNS8bfDmqmoGk
	 vZCQFNNYgXQwUV7CPc7dbsRUJUGJlyhV1NGRFE5yp/HqkvpiZuVA7mKViCSPWxDGWE
	 nETthuPrDofCnOZ3AXzDFAeJO1pcZqEp1xhWqXjY=
Message-ID: <749fcbf2e2094606b31a07ba3d480bd90d7c1890.camel@HansenPartnership.com>
Subject: Re: [PATCH] Add ability to disallow idmapped mounts
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Anton V. Boyarshinov" <boyarsh@altlinux.org>, Christian Brauner
	 <brauner@kernel.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, 
 ebiederm@xmission.com, legion@kernel.org, ldv@altlinux.org, 
 linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
 Christoph Hellwig <hch@lst.de>, Linus Torvalds
 <torvalds@linux-foundation.org>
Date: Sat, 05 Feb 2022 08:57:34 -0500
In-Reply-To: <20220205105758.1623e78d@tower>
References: <20220204065338.251469-1-boyarsh@altlinux.org>
	 <20220204094515.6vvxhzcyemvrb2yy@wittgenstein>
	 <20220204132616.28de9c4a@tower>
	 <20220204151032.7q22hgzcil4hqvkl@wittgenstein>
	 <20220205105758.1623e78d@tower>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 2022-02-05 at 10:57 +0300, Anton V. Boyarshinov wrote:
> В Fri, 4 Feb 2022 16:10:32 +0100
> Christian Brauner <brauner@kernel.org> пишет:
> 
> 
> > > It turns off much more than idmapped mounts only. More fine
> > > grained control seems better for me.  
> > 
> > If you allow user namespaces and not idmapped mounts you haven't
> > reduced your attack surface.
> 
> I have. And many other people have. People who have creating user
> namespaces by unpriviliged user disabled.

Which would defeat the purpose of user namespaces which is to allow the
creation of unprivileged containers by anyone and allow us to reduce
the container attack surface by reducing the actual privilege given to
some real world containers.

You've raised vague, unactionable security concerns about this, but
basically one of the jobs of user namespaces is to take some designated
features guarded by CAP_SYS_ADMIN and give the admin of the namespace
(the unprivileged user) access to them.  There are always going to be
vague security concerns about doing this.  If you had an actual,
actionable concern, we could fix it.  What happens without this is that
containers that need the functionality now have to run with real root
inside, which is a massively bigger security problem.

Adding knobs to disable features for unactionable security concerns
gives a feel good in terms of security theatre, but it causes system
unpredictability in that any given application now has to check if a
feature is usable before it uses it and figure out what to do if it
isn't available.  The more we do it, the bigger the combinatoric
explosion of possible missing features and every distro ends up having
a different default combination.

The bottom line is it's much better to find and fix actual security
bugs than create a runtime configuration nightmare.

>  I find it sad that we have no tool in mainline kernel to limit users
> access to creating user namespaces except complete disabling them.
> But many distros have that tools. Different tools with different
> interfaces and semantics :(

Have you actually proposed something?  A more granular approach to
globally disabling user namespaces might be acceptable provided it
doesn't lead to a feature configuration explosion.

James


