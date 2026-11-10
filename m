Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 075BE606A31C
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Nov 2026 21:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vhp1k43Y
Received: (qmail 9876 invoked by uid 550); 10 Nov 2026 21:45:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9811 invoked from network); 10 Nov 2026 21:45:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794347092;
	bh=tdWhXPI4NaO/Cls8tJ8AG06VrGrrQqcMlv00UocY5dM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vhp1k43YzpaxqgAvraXM8pNsdJ6AF370YBvkbrlQ4PAEJkMC3U0S5R7fiOG3mX4mM
	 RTZgNREMJ3zI6QlKEDLjYumoltzLIfHoihj+pjsJ6rHssYYeRkZGNfdU9r5VgHq4A6
	 9k/hMPrx95CzigwD2u8jy4++LgrsngvsokdlaLqk=
Date: Tue, 10 Nov 2026 16:44:51 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Nakashima Seiichi <s-nakashima@kjb.biglobe.ne.jp>
Cc: kernel-hardening@lists.openwall.com,
	linux-security-module@lists.linux.dev, keescook@chromium.org,
	paul@paul-moore.com, mic@digikod.net
Subject: Re: [RFC v3] kaf: CVE Emergency Mitigation Policy Standard
 Specification
Message-ID: <2026111040-splurge-rotunda-940c@gregkh>
References: <f5298260b9354b674f4954868755682398f05e83.camel@kjb.biglobe.ne.jp>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5298260b9354b674f4954868755682398f05e83.camel@kjb.biglobe.ne.jp>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 05:56:02AM +0900, Nakashima Seiichi wrote:
> embargo  The period before public CVE disclosure during which vendors are aware
> period   of the vulnerability but it is not yet public.

The kernel does not have "embargo" time periods where any vendors are
aware of a vulnerability but it is not public, sorry.  That's just not
how we operate.  Please point your LLM at our documentation so it
doesn't get these types of basic things wrong.

greg k-h
