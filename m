Return-Path: <SRS0=wJaW=FT=lists.openwall.com=kernel-hardening-return-20607-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF46C2BB9A
	for <kernel-hardening@archiver.kernel.org>; Tue, 15 Dec 2020 06:10:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0908320798
	for <kernel-hardening@archiver.kernel.org>; Tue, 15 Dec 2020 06:10:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0908320798
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20607-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30718 invoked by uid 550); 15 Dec 2020 06:09:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30685 invoked from network); 15 Dec 2020 06:09:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qTC/ZFdBV4bfFnGdBAMxOiVS8IVB9B7BDasYdtfr3Kk=;
        b=Pe6FVTkSbDl3k1ES+hAL5ydvu6Fd6KWauGwno8sPnJm6uCYVkoVoayxm5VCvNan2Bh
         a7Kf+q5YLohn1ptNHBk0G+9elIzHtHgQ1/l03bFbhI8ae6obbdebOC4hbn/iaU8rszg0
         u9YlDBPaxWMiMmZRaXpKRdOFE9PnJF360OCsShddqZR+KRZ2WKfUcpWnB0R0lt3q8d7d
         F5X1+DY78eMpdrRs9e94ShYE8QNy5VGsKIql+eABk/KsSfjN0joKxZ3bYxGRLUad30Jg
         7frXmqhjXsdfTP9WQs6OJAO8Y6s/1n0jDS94817VsOId2yYJSSgOBoPqWzKZRG8TI4Vo
         7Ieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qTC/ZFdBV4bfFnGdBAMxOiVS8IVB9B7BDasYdtfr3Kk=;
        b=VlBl1uVLx3I70o9GYX7Uev+tpMMMp69jiNqX4W2x4DUHWAm8kKMgM/f1Pzm5y0lI6g
         uXl3w4SLxx0rKxmtlw4D1jfd1qIdPDPCEPk16q2KiZcUl7Z8Aqo4S3Mqd0HSKYaSvKWX
         NqX43lbG6ep1ANtEzIP8/sxMzfdOzUiLHlmOwrmRWB/LBi2UQn2ZSnWTHGVRm6vWCq/q
         z2QJt252q6uhjO+8Mw3A0TO29GKKKgi9krSoaAtZVtTCkhmVDPHyRgH6v6Nhr3haZYLO
         r7kOkRP5vlq903R3jI/bh6hvWjWjV7duLSGqRQNwUEs9YFbg229S1S2KGwAmDPC5trFL
         AGQg==
X-Gm-Message-State: AOAM530OYUmaizh70RooyCkXVni242kq8F2J8KzDgQAGNLrt+FnqUAE/
	54DRwKVwTn9TUWb/3azmfjH98PVq1GHCnmqU75k=
X-Google-Smtp-Source: ABdhPJwGbzWHZ05gHw1j32jLgtdFdWbst+7Qdh9hLzKs+B2cmL1gz9UqDF0J2hkj9RmcUASDgSduK19wiId5c5MrGXw=
X-Received: by 2002:a1c:c305:: with SMTP id t5mr31602285wmf.63.1608012582793;
 Mon, 14 Dec 2020 22:09:42 -0800 (PST)
MIME-Version: 1.0
References: <X9UjVOuTgwuQwfFk@mailbox.org>
In-Reply-To: <X9UjVOuTgwuQwfFk@mailbox.org>
From: Sandy Harris <sandyinchina@gmail.com>
Date: Tue, 15 Dec 2020 14:09:30 +0800
Message-ID: <CACXcFmnrQmQO38yBXh25eD9QgtvjKHTg=oCtJm8Kq6coK+WspA@mail.gmail.com>
Subject: Re: Kernel complexity
To: stefan.bavendiek@mailbox.org
Cc: kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> I am currently doing a research project that aims to identify risk areas in the kernel by measuring code complexity metrics ...

Another aspect of complexity that might be worth a look is
modularisation, interface definitions for kernel components, etc. One
classic paper is "Ifdef Considered Harmful".
https://www.usenix.org/legacy/publications/library/proceedings/sa92/spencer.pdf
