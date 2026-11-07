Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id F0E78606A32D
	for <kernel-hardening@archiver.kernel.org>; Sat,  7 Nov 2026 12:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FntdjZ0d
Received: (qmail 24503 invoked by uid 550); 7 Nov 2026 12:05:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24458 invoked from network); 7 Nov 2026 12:05:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794053093;
	bh=pcEn2PfNJ1rcvL6/N+cQBhnEAS4/g/yd+2X4qbZ5yvo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FntdjZ0dxfEkDp8XBxO+LlgBAd5XnkLTPW3d6BwzW9wjr25edkBIbA39LY1Izn+IZ
	 lolnA9LPRnuP5AqyBJICC4CVeUwf8/z9UeCmzkmEtchIazjUSw1zJWQIdGmbnf3IpN
	 DUPddx+gfH0iivaHcgEWYPxSpiLtarveUeQZ/tg8=
Date: Sat, 7 Nov 2026 07:04:50 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Boris Lukashev <blukashev@sempervictus.com>
Cc: Nakashima Seiichi <s-nakashima@kjb.biglobe.ne.jp>,
	kernel-hardening@lists.openwall.com, mic@digikod.net,
	paul@paul-moore.com
Subject: Re: [RFC idea] Kernel API Firewall (kaf): subsystem-level attack
 surface reduction for the post-AI-CVE era
Message-ID: <2026110719-zipping-silliness-2443@gregkh>
References: <ca90b945049ac3c27f3e1d9b8181137feb892436.camel@kjb.biglobe.ne.jp>
 <2026110611-tassel-bubble-dc09@gregkh>
 <1cd0f5e304584ab9d0a595a5d35b5649dc232fb2.camel@kjb.biglobe.ne.jp>
 <CAFUG7CciO_ZUMdjcOCfOtoi+YEni2+a-9QkcsCj1nox0NqHj0A@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFUG7CciO_ZUMdjcOCfOtoi+YEni2+a-9QkcsCj1nox0NqHj0A@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_20,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 04:00:48PM -0500, Boris Lukashev wrote:
> @Greg KH:  there is no practical choice for using anything but what's
> prescribed by the vendor and contractually supported in the commercial
> world (further complicated by binary blobs/device trees/intellectual
> property concerns/etc). You cant ask the hotel to change the kiosk
> distribution to a safer one in order to check you in despite them having
> your PII and payment data running through it any more than the rest of us
> despite your undeniable awareness of the threat involved. It would be far
> more realistic and practical for the Linux Foundation to assign its
> seasoned talent to work on downstream distributions of economic relevance
> to its member entities than to swap out the OS' in the clustered engine of
> today's economy.

So, it's not enough that the kernel developers and stable maintainers
provide a free feed of 75 fixes a day in a tested and released kernel,
and 55 documented CVE fixes a day, they then are required to, for free,
take those patches and integrate them into for-profit company's kernels
for them because that for-profit company doesn't want to pay for that
effort to meet the contractual requirements that their customers pay for
them to meet?

If you take the "pure numbers" point of view, that means that we should
do this only for Debian and Yocto as those distros hold the huge
majority of all of the server and embedded systems numbers in the world,
everything else is just a tiny percent.  Oh wait, the LF already does
this for you, for Yocto, and Debian is also free and up to date with all
of these security issues for you to rely on.

So again, why not hold the companies that you feel are worth paying for
this service, responsible for meeting their own self-defined
contractural requirements?  Given that the community is giving all of
this to them for free, it's odd that anyone would ask for us to do more
work than that, don't you agree?

greg k-h
