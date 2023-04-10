Return-Path: <kernel-hardening-return-21657-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 6A1E6C77B6F
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Apr 2023 18:37:34 +0000 (UTC)
Received: (qmail 3296 invoked by uid 550); 10 Apr 2023 18:37:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3252 invoked from network); 10 Apr 2023 18:37:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681151829;
	bh=623dasWmscGyY+Q6atpJKWeyuHlDLhJJ8TIjaQYzSrU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p3OClRvqnLBy1hGAjb3FSqiTeoVDoPJGpup53Tn85z/FxfMpHxH6AuWQOiw5w2IiS
	 FXQiw+gY+9HL3nuuN30LropRwfBWPOejmegpBKzvE+4jIc/CDxSHcDhl3y7AO2vrBp
	 QbdUIKN/hnM9A1PiB6yS05gzQe2TtdQDVAyQLPOU=
Date: Mon, 10 Apr 2023 20:37:06 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Topi Miettinen <toiwoton@gmail.com>
Cc: linux-modules <linux-modules@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Per-process flag set via prctl() to deny module loading?
Message-ID: <2023041010-vacation-scribble-ba46@gregkh>
References: <640c4327-0b40-f964-0b5b-c978683ac9ba@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <640c4327-0b40-f964-0b5b-c978683ac9ba@gmail.com>

On Mon, Apr 10, 2023 at 01:06:00PM +0300, Topi Miettinen wrote:
> I'd propose to add a per-process flag to irrevocably deny any loading of
> kernel modules for the process and its children. The flag could be set (but
> not unset) via prctl() and for unprivileged processes, only when
> NoNewPrivileges is also set. This would be similar to CAP_SYS_MODULE, but
> unlike capabilities, there would be no issues with namespaces since the flag
> isn't namespaced.
> 
> The implementation should be very simple.

Patches are always welcome to be reviewed.

But note, please watch out for processes that cause devices to be found,
and then modules to be loaded that way, it's not going to be as simple
as you might have imagined...

thanks,

greg k-h
