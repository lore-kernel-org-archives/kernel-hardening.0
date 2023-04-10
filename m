Return-Path: <kernel-hardening-return-21659-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 71298C77B61
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Apr 2023 21:04:53 +0000 (UTC)
Received: (qmail 13730 invoked by uid 550); 10 Apr 2023 21:04:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13698 invoked from network); 10 Apr 2023 21:04:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681160673;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ko7QXPbIjeGGHDhMu4npXiL/4qFqfqYW7bib84R6aNU=;
        b=lpvPFtUOP3XhFCJ7Xk611x6D8hZ+kTQRj1OcX61VyNYNxN/okXXr2n0MjOXIdaRTEX
         82X3Em+8AMDFbbbRUwRG8a7Xc8Lx6ZScGdRX6NOVgo6/cH1f86RKS1JERLXxS1ee5XPA
         l0dbCOfG1OLPRgdNiWF/yFY+6oreawyFJAJXcKKVAVFo7+RtnECs3NkVfComi6WdiG/E
         PHbInMiKfIX1fVzaco+up5yfev/cckrlYksisO9zJeMW2s46ujRMdGzrULItwIOWAlGv
         FFwrQLY6qXbV7HTnuOXTLPO5fGmROzrgTQDGxMwKcvu4vXJRa3VB2WCbx8Y2YF4vFlGP
         OE+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681160673;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ko7QXPbIjeGGHDhMu4npXiL/4qFqfqYW7bib84R6aNU=;
        b=h+6uZR1fO6qODNjhiZhQPrl3aixC3VrmXP2PQleXbKwZBvQf6aQ4emBY3ei+aiRQMF
         c0SDXAIoMRSsEvR4gQLERMplmH1HOb936ZQS7Xkf3r0BEvzCsNJhpDBDsdA1OjrFai0u
         vDeZbg4JJd6Er4UWYKV7bf7F3KT/uh9DIIJs3k623wd1T1A2dY2j4wDSFiRCqBL0kAwz
         wvEtbe2Q3mqY0v1wkwkAgzZFXGl0Yla5PYvoelBcDelKq/1NJoYFB7qRML/zbo4j1n6q
         4GBvy+iaDBwN1pK8vlefVrfIQ1/wxRNGlVHLJDxR3YncAA5aZOMBRhaXWa+2dD/G1WLU
         N9sQ==
X-Gm-Message-State: AAQBX9eHzRzy6RNBiyZa+IOvCeISTbNY+4GGPv8yjwVun6CypUSqDub3
	JkP/QCI0vKkoso3yJSTpGIo=
X-Google-Smtp-Source: AKy350aaXf7tXMoq/bDIX5RcTUjwlvNj4/ZV58esCJnG/KA/wgu03yQ50TGQoFVlOrSEBxSV3L5hJg==
X-Received: by 2002:ac2:5929:0:b0:4dc:828f:ef97 with SMTP id v9-20020ac25929000000b004dc828fef97mr3028369lfi.60.1681160672813;
        Mon, 10 Apr 2023 14:04:32 -0700 (PDT)
Message-ID: <52301293-0e21-2885-904b-776b82d5a18d@gmail.com>
Date: Tue, 11 Apr 2023 00:04:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: Per-process flag set via prctl() to deny module loading?
Content-Language: en-US
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-modules <linux-modules@vger.kernel.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <640c4327-0b40-f964-0b5b-c978683ac9ba@gmail.com>
 <2023041010-vacation-scribble-ba46@gregkh>
From: Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <2023041010-vacation-scribble-ba46@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.4.2023 21.37, Greg KH wrote:
> On Mon, Apr 10, 2023 at 01:06:00PM +0300, Topi Miettinen wrote:
>> I'd propose to add a per-process flag to irrevocably deny any loading of
>> kernel modules for the process and its children. The flag could be set (but
>> not unset) via prctl() and for unprivileged processes, only when
>> NoNewPrivileges is also set. This would be similar to CAP_SYS_MODULE, but
>> unlike capabilities, there would be no issues with namespaces since the flag
>> isn't namespaced.
>>
>> The implementation should be very simple.
> 
> Patches are always welcome to be reviewed.
> 
> But note, please watch out for processes that cause devices to be found,
> and then modules to be loaded that way, it's not going to be as simple
> as you might have imagined...

A very simple version would only add a simple check like 
!current->allow_module_load after every !capable(CAP_SYS_MODULE). It 
wouldn't block all the ways how modules could be caused to be loaded 
indirectly.

I think a less simple version could also do the check at __request_module().

-Topi

