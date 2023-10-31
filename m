Return-Path: <kernel-hardening-return-21717-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id F0EC2C4332F
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Oct 2023 20:41:28 +0000 (UTC)
Received: (qmail 9444 invoked by uid 550); 31 Oct 2023 20:41:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9409 invoked from network); 31 Oct 2023 20:41:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1698784862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hp84yni3w/m2CKBcr8zWmoOxEanjZqgFnmWK7QtuKS8=;
	b=i/jv3PeMhFyh7wm+fl1zxdbyeMI/XAkZIyzsMyEgro+TVMubumzpYEYj3aOKHR8y3EdVxL
	CFi2K331V7mvMDFi39iW2uAXCvNJ3VmGZZ7CP6LTJlGZ+aC1B/E0jVSpUwWt7mQXwwIzdp
	HQ34bOmD6dgypT24HGcc+DYmC+mRIAf2oVoqQ77bR+N78VaYf9q1X4RU1lrgHa898dC61R
	bf5bFPsHKaV1d69ATAbOgGmTcTrAI0WxA+ctPC6rQ4IvXTe28sv+wRZmz2ONIhWqEHf4gH
	9zTT5dUzs+e1JWB/pMIHX8JITq4BKjcmdFm5LwxSmfEqCDHGFaoPxiwhIw1Ktw==
Date: Tue, 31 Oct 2023 21:40:59 +0100
From: Stefan Bavendiek <stefan.bavendiek@mailbox.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
Subject: Re: Isolating abstract sockets
Message-ID: <ZUFmW8DrxrhOhuVs@mailbox.org>
References: <Y59qBh9rRDgsIHaj@mailbox.org>
 <20231024134608.GC320399@mail.hallyn.com>
 <CAHC9VhRCJfBRu8172=5jF_gFhv2znQXTnGs_c_ae1G3rk_Dc-g@mail.gmail.com>
 <20231024141807.GB321218@mail.hallyn.com>
 <CAHC9VhQaotVPGzWFFzRCgw9mDDc2tu6kmGHioMBghj-ybbYx1Q@mail.gmail.com>
 <20231024160714.GA323539@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024160714.GA323539@mail.hallyn.com>
X-MBO-RS-META: udxo1pudytbk3n81hxb7scqspsm554uf
X-MBO-RS-ID: b50aa093106517e0fc2

On Tue, Oct 24, 2023 at 11:07:14AM -0500, Serge E. Hallyn wrote:
> In 2005, before namespaces were upstreamed, I posted the 'bsdjail' LSM,
> which briefly made it into the -mm kernel, but was eventually rejected as
> being an abuse of the LSM interface for OS level virtualization :)
> 
> It's not 100% clear to me whether Stefan only wants isolation, or
> wants something closer to virtualization.
> 
> Stefan, would an LSM allowing you to isolate certain processes from
> some abstract unix socket paths (or by label, whatever0 suffice for you?
>

My intention was to find a clean way to isolate abstract sockets in network
applications without adding dependencies like LSMs. However the entire approach
of using namespaces for this is something I have mostly abandoned. LSMs like
Apparmor and SELinux would work fine for process isolation when you can control
the target system, but for general deployment of sandboxed processes, I found it
to be significantly easier (and more effective) to build this into the
application itself by using a multi process approach with seccomp (Basically how
OpenSSH did it)

- Stefan
