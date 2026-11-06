Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id CB156606D804
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Nov 2026 17:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fCXY32L2
Received: (qmail 23685 invoked by uid 550); 6 Nov 2026 17:20:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23629 invoked from network); 6 Nov 2026 17:20:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793985590;
	bh=8fVlDt5AkafHuPDPToKofqzbI2LGXYVlW9Oha4vFOek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fCXY32L2jdmleV9AEMvz3Sun4hiLlnUDfUIcfzew3pMGeTVUno2jeHNP71d/mdrza
	 7T+KAGF0q/yAMXyO1++VJwog7T5MBc7EgR32cTEHLKAXNAi+XmIElkMO4Qk0l2Lcfz
	 IW4MgUCMckH3TTSUkNjJdzMOgwErrWxUqnqO/zQk=
Date: Fri, 6 Nov 2026 12:08:00 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Nakashima Seiichi <s-nakashima@kjb.biglobe.ne.jp>
Cc: kernel-hardening@lists.openwall.com,
	mic@digikod.net, paul@paul-moore.com
Subject: Re: [RFC idea] Kernel API Firewall (kaf): subsystem-level attack
 surface reduction for the post-AI-CVE era
Message-ID: <2026110611-tassel-bubble-dc09@gregkh>
References: <ca90b945049ac3c27f3e1d9b8181137feb892436.camel@kjb.biglobe.ne.jp>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca90b945049ac3c27f3e1d9b8181137feb892436.camel@kjb.biglobe.ne.jp>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 08:15:26PM +0900, Nakashima Seiichi wrote:
> Users are left with three bad choices:
> a) Wait indefinitely for distro patches

Pick a better distro.  Seriously, if the distro you are paying for isn't
keeping it up to date and secure, what are you paying them for?  Seems
like an odd choice to stick with them given you have a contract saying
they need to abide by it...

good luck!

greg k-h
