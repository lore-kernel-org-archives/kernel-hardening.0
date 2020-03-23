Return-Path: <SRS0=k2KC=5I=lists.openwall.com=kernel-hardening-return-18155-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB492C3F2CD
	for <kernel-hardening@archiver.kernel.org>; Mon, 23 Mar 2020 19:16:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1A5422072D
	for <kernel-hardening@archiver.kernel.org>; Mon, 23 Mar 2020 19:16:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JR8Td2VW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A5422072D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18155-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16264 invoked by uid 550); 23 Mar 2020 19:16:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16232 invoked from network); 23 Mar 2020 19:16:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LfJMiV/49sj6L4e81DHhjEgnfxf9d3EZ6mYKtA8MhxI=;
        b=JR8Td2VWwalrpJKkB6gyz340vs5CKMXWDL4GtX8wY0n0eivLT88RJL9ROpeRBlTnps
         zDRwLBb/EnS0/fGhGWpxIqyxaB0WezdvrZcSOkWz1cLg/np3NoODiXK/75Zt8a6fgZ92
         g+nz1LekACPXNgS+ZZzfv0gopma16H6jZq/aE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LfJMiV/49sj6L4e81DHhjEgnfxf9d3EZ6mYKtA8MhxI=;
        b=cDQBvkx9OkBUdfWW4w5qcaXiy/yCQvcHchBw3zLk0HayHxKXUk/plUzrEB5Rh3v6dC
         WX7W0mf3lvzf5YJR1rNbk2/WjO993PW+rKLsL7i++gsqsPGvPChimIQGoDpu7tsjq4ck
         H3HdQxOodYDhBVZNexo+dloqnHhIwhKIU8fz9l9rvbBwcqoyH3k3W11cVKVSqMeNclY8
         5lUP9KX2qfReOYRxcokaphRCyKv2/Gwq29hDjMeQGFWzanpGkDBt80vG8LO4LiTwJW3A
         fXOunPqgB47FcnJseG53qqpQV71+ABNjzx+soj8JKp6bszvDWVbmw+49CKwN37jmHHLI
         iguA==
X-Gm-Message-State: ANhLgQ1vuARZk08VvzrZxBxpC/+CGFx0Fnc3OwCh/fjsQChYr9GVpBwL
	KjxF1IZEwzKL2N8NokUYYBO27i1OscA=
X-Google-Smtp-Source: ADFU+vt5xsBbDjsNMby5NYY/aH//ITEKmaBHDiX1nskNdQbxj9RXWF444kcSoQXuq/dD8xGzzycRaQ==
X-Received: by 2002:a17:902:169:: with SMTP id 96mr22673905plb.140.1584990990982;
        Mon, 23 Mar 2020 12:16:30 -0700 (PDT)
Date: Mon, 23 Mar 2020 12:16:27 -0700
From: Kees Cook <keescook@chromium.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: Looking for help testing patch attestation
Message-ID: <202003231214.4669C6088@keescook>
References: <20200318163930.5n545jfsbenc5vyr@chatter.i7.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318163930.5n545jfsbenc5vyr@chatter.i7.local>

On Wed, Mar 18, 2020 at 12:39:30PM -0400, Konstantin Ryabitsev wrote:
> If you are interested in participating, all you need to do is to install 
> the "b4" tool and start submitting and checking patch attestation.  
> Please see the following post for details:
> 
> https://people.kernel.org/monsieuricon/introducing-b4-and-patch-attestation
> 
> With any feedback, please email the tools@linux.kernel.org list in order 
> to minimize off-topic conversations on this list.

Thanks for reaching out! I'll be switching to b4 shortly -- I already
incorporated the earlier version of this tool into my workflow. It's very
easy. I recommend everyone else here give it a try if you're regularly
sending patches around by email. :)

-Kees

-- 
Kees Cook
