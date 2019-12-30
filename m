Return-Path: <SRS0=8JR5=2U=lists.openwall.com=kernel-hardening-return-17538-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C4DBC2D0C2
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Dec 2019 18:52:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7C2ED206DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Dec 2019 18:52:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bHZS9r+D"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C2ED206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17538-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15382 invoked by uid 550); 30 Dec 2019 18:52:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14332 invoked from network); 30 Dec 2019 18:52:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2PU80e06dVsLEFBPoBP15a3a0bqTWpgCtffJm4G5PGU=;
        b=bHZS9r+DC7xoeD6cxpH4i3xpSJ/gq50CwlupX1697alL9zoV2RniiOpeS0fzfamIQa
         WxQ7cCBNSANfXeX4NY4r/hZFK4P1w1JlyzXv9TnOkQRK0d1M4ZscNJljNFAQFM5GFlOM
         35xcjwPPMRp352B/JuDt4EKyWZZ4Uo+a1Db+c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2PU80e06dVsLEFBPoBP15a3a0bqTWpgCtffJm4G5PGU=;
        b=JbUSe0Qk54BaBpC3hPjE6jRGrqESvB+O2gC9cKFEpWJDxmcHUO2rm/IqVBa2An/JK0
         H0E/XwUcn2221STciLSrudhalke0Ilq5CSKUMruzR9Zfn044ftMrQ3HauANx6LNdLwdA
         lwcf2dcGFV/ng39iRCPC2Kk9QqN4KqfEDB2TsImm2+aFQ3IfO0WNJBLKgiN2l7QFPSQ/
         awAnWJzfjFFYVMnOug1fWYVoQbA94XnkwselNhn1whbu/qUvbtDtPG4A9zBsD/ONY/QC
         H4SHkpArAee/4+1iNb0MT8swi9e0X3xl9MSPmkL03JpjZ4WzjxjeI6Eh+l63yQDrYvu2
         cPyg==
X-Gm-Message-State: APjAAAXF6nXeUD1wmANXCCrpJ0JfW89qcEnw6KbGza7tZ8v0gqCM6ukL
	QDfhCAgL+fCeru+IJT26senKPg==
X-Google-Smtp-Source: APXvYqyRXCmINU65Y6yuKMiO/XiDPdUu64Vn+VoIxbx6ttD2OgkwUiThd7nh2RnWqHJyh6C1czL/mQ==
X-Received: by 2002:a9d:748d:: with SMTP id t13mr73212089otk.181.1577731950592;
        Mon, 30 Dec 2019 10:52:30 -0800 (PST)
Date: Mon, 30 Dec 2019 10:52:28 -0800
From: Kees Cook <keescook@chromium.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Garnier <thgarnie@chromium.org>,
	kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	"VMware, Inc." <pv-drivers@vmware.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>, Jiri Slaby <jslaby@suse.cz>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexios Zavras <alexios.zavras@intel.com>,
	Allison Randal <allison@lohutok.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v10 00/11] x86: PIE support to extend KASLR randomization
Message-ID: <201912301052.16438D6@keescook>
References: <20191205000957.112719-1-thgarnie@chromium.org>
 <20191224130310.GE21017@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224130310.GE21017@zn.tnic>

On Tue, Dec 24, 2019 at 02:03:10PM +0100, Borislav Petkov wrote:
> On Wed, Dec 04, 2019 at 04:09:37PM -0800, Thomas Garnier wrote:
> > Minor changes based on feedback and rebase from v9.
> > 
> > Splitting the previous serie in two. This part contains assembly code
> > changes required for PIE but without any direct dependencies with the
> > rest of the patchset.
> 
> Ok, modulo the minor commit message and comments fixup, this looks ok
> and passes testing here.
> 
> I'm going to queue patches 2-11 of the next version unless someone
> complains.

Great! Thanks very much for the reviews. :)

-- 
Kees Cook
