Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 5578D606A321
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Nov 2026 21:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sDIO4Y6y
Received: (qmail 27726 invoked by uid 550); 10 Nov 2026 21:52:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27701 invoked from network); 10 Nov 2026 21:52:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794347563;
	bh=i0+zYI8kdiBWsDryds3EEzsTydcCxxKO3QkUoki2DtA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=sDIO4Y6yuRUfqi6E2szdfJbKm9QMjfcyDUfa+ngAdKZw0koMXdlRzxNElnbUmzfVG
	 /8MqSfKkcBGtgP6Ia+SJanxClk/AVzLULJlMIuT3fT5TgyAAVe6Fhi5va8G1QiPbor
	 o9EM8rkKcySUoZLLymJNJbSudwWdR71N6yOqevO8=
Date: Tue, 10 Nov 2026 16:52:41 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Nakashima Seiichi <s-nakashima@kjb.biglobe.ne.jp>
Cc: kernel-hardening@lists.openwall.com,
	linux-security-module@vger.kernel.org
Subject: Re: [Case Study] CVE-2024-0582: Why We Need a Standard for CVE
 Emergency Mitigation
Message-ID: <2026111052-spectator-legwarmer-4c1e@gregkh>
References: <1d9ab7140a015e94829e2356a4c6c9e18d92b864.camel@kjb.biglobe.ne.jp>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d9ab7140a015e94829e2356a4c6c9e18d92b864.camel@kjb.biglobe.ne.jp>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 06:28:39AM +0900, Nakashima Seiichi wrote:
> The case study demonstrates the gap between "technically possible"
> and "operationally scalable." With a standardized framework, the
> mitigation could have started on CVE publication day instead of
> waiting ~2.5 months for the distro patch.

There was a working patch before the CVE was issued, so who is waiting 2
1/2 months for anything?

Also, remember we are issuing about 55 CVEs per day right now, who is
going to do all of this review and "mitigation" for all of those
entries?  That's almost 2 per hour, 24 hours a day.  Do you have the
free tokens to burn on that?

And again, why?  You have a fix.  Given to you for free.  Just apply it.

good luck!

greg k-h
