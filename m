Return-Path: <SRS0=ZFOV=4N=lists.openwall.com=kernel-hardening-return-17921-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E6C2C35E01
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 18:50:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E4DA121556
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 18:50:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G7bWyZbH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4DA121556
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17921-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5698 invoked by uid 550); 25 Feb 2020 18:50:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5666 invoked from network); 25 Feb 2020 18:50:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=nvwGkkcwwig4eCR4m0+EXyPalZCNu0nCU8n4Iqik970=;
        b=G7bWyZbHZX8L5mx1qmuUrJ6R/u1VcW6191mW+YfJDBC8HLgDFKfKHWQEOoEJoVhkXn
         W/y6CCVqFL92NYn57nNRjyHA6lwYbRoweC1yYGHTkJzL53mymmUpJksjTWZ7ySbaPrRB
         n0dyGnxfMmOFoTSoRJbqDT3MGEuqUxVvZXV12P4m3+0oJWHi3DH5TMF+x/W1qg0hNMxA
         CLweY4F1EeybVJFQ04jKbevHMx8Vcg43jgMKOzPQ4W+7RIFDB5lRmOdZqHKK6pq4BKkF
         NJ9ve8xEqDSWGj1UXvCZkB5iZd0pmON/92SSjvdIELk2bdaMvOd6OKLXHoTzYJLCvTa+
         zcpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=nvwGkkcwwig4eCR4m0+EXyPalZCNu0nCU8n4Iqik970=;
        b=PL6B4Mkzc4Lnk5sk1jt7SrVq5hu23keR/PupC88D1odgNY2VrQ0+Wr8VuvQSFxWnzs
         iQuUScyhiFIpW0NiU8Lwd2BLUED2TqEdUp6DvHe2c2a+zKTu30Qmu3SzflbRhjDAnwOL
         56HsCOYlxQOrMamoeKJLwBy7f32F8dmScy47ju/mbvEpnWaEyYN2l1W7ClkI+sIanJdc
         7CyFMukUvEa1RPtTa3CzrnQqkj6XOkayuPVMCC+sAAvJEqXtUhiwDmOnERbnwyr3KJZ9
         4z7ERzRik4rG/GGZWizAqy1q7dsWecpll4W5C5DgB8E+qjWeMMkqC5uLQmh5aHXhfw0D
         1lnw==
X-Gm-Message-State: APjAAAXAgh6lqdINAMwqTrcUStXUqWCyroDxf1rUpqRR0IQp+b6e5HSZ
	q0OTVIu/6OuUToXIApd5kPs=
X-Google-Smtp-Source: APXvYqwqCzAhzlldh7y2QteC8HJxHmiV+T+MgbEcZee4Qfdqy017TQ2Ol+QM4KbM9t0bb8tGyUsHwA==
X-Received: by 2002:a17:902:bc45:: with SMTP id t5mr56453991plz.239.1582656596777;
        Tue, 25 Feb 2020 10:49:56 -0800 (PST)
Subject: Re: [RFC PATCH v14 00/10] Landlock LSM
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
 linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
 Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-security-module@vger.kernel.org, x86@kernel.org
References: <20200224160215.4136-1-mic@digikod.net>
From: J Freyensee <why2jjj.linux@gmail.com>
Message-ID: <6df3e6b1-ffd1-dacf-2f2d-7df8e5aca668@gmail.com>
Date: Tue, 25 Feb 2020 10:49:52 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200224160215.4136-1-mic@digikod.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB



On 2/24/20 8:02 AM, Mickaël Salaün wrote:

> ## Syscall
>
> Because it is only tested on x86_64, the syscall is only wired up for
> this architecture.  The whole x86 family (and probably all the others)
> will be supported in the next patch series.
General question for u.  What is it meant "whole x86 family will be 
supported".  32-bit x86 will be supported?

Thanks,
Jay

