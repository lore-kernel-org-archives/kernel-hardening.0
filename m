Return-Path: <kernel-hardening-return-21588-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 6EEA1C4332F
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Nov 2022 16:04:37 +0000 (UTC)
Received: (qmail 16008 invoked by uid 550); 9 Nov 2022 16:04:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11288 invoked from network); 9 Nov 2022 15:59:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kMpz0htQ7/MGd5vuDayKM00Lvv56YDt4hT+zhs8g2Ss=;
        b=DxPii1rwpWX2KNM5w6aU83V4P3pvCEWJ+OmIRRU67Ed9ghnzy/dQxWPypq6nc8KYq2
         7z7ReF/5u/9goEHI9sjm6aqEfwD3Dm0+URnSHRERstVHqeWod2vS+lnqtEkfyWsAZKtk
         RbTK7hh0N0Re5P+xD3+fdpgA9OnxaGC2bHWncjxstBmqbtuEI1xxQ2WvdJ9Nde5cdEed
         OBTx0QZTjNsnnXcrsODJBHWQn5QAwF32qdWc5/k9Garax/RG6gxVZ/Irrcj3nPj4nBFR
         aUy7nvaFnOg+YVvqk+UtIGsHLPWWKo4Fup4GJZ7ULRJOzKiMKf68sAaaeC+jplrU44PQ
         LKRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kMpz0htQ7/MGd5vuDayKM00Lvv56YDt4hT+zhs8g2Ss=;
        b=54YbT21IiVF8niPsSDnuckxsMNzLRU0yENgtJfwmNnfb5CLCX9OSzpc1mXRO9pWyuf
         8eJxIq9oOv48ocyHHeZCxs50OehQE2VW8QVVOSsMDCUo9hQ06YLqefyoek2hgupiyFPD
         SfY0/ZSe6U5wbl5hGarG+EwIDg4+3nqOlAcYghuQ71sPmWWEpUxq9SozPC9u/S3LOhyA
         y/duBodP61zul8wCLiQtx4UL0R8Qu6wv+JmlikQDEVgpRLGP5lMZPcK82NDkVwYsiXj3
         NEOZd0GAwa8Mh4B6EwmsuIbq9JCuUatwD3ePWMGPJ7N8wq3Fmmq+2iftRdPyF6zkMweI
         UGmQ==
X-Gm-Message-State: ACrzQf18TarvPFQ11neyFwTP/kO8I6hIlj+YtZXtdBWiWTnhd/RdleJH
	B8lYVc3o5FdjnYHVRXDCGvjTwmQe8D3HGn45wI1afA==
X-Google-Smtp-Source: AMsMyM6KcsdIruaq2XMS8h3WG9IGI3ifDSKwPpa34n/XxwnANIIvZR1obFMCRGMiLLfgo0+LTXJDaGAweOynKOsEtMc=
X-Received: by 2002:a17:906:7048:b0:7ae:db2:f10a with SMTP id
 r8-20020a170906704800b007ae0db2f10amr1136400ejj.709.1668009558671; Wed, 09
 Nov 2022 07:59:18 -0800 (PST)
MIME-Version: 1.0
References: <20221107201317.324457-1-jannh@google.com> <3e2f7e2cb4f6451a9ef5d0fb9e1f6080@AcuMS.aculab.com>
 <CAG48ez3AGh-R+deQMbNPt6PCQazOz8a96skW+qP3_HmUaANmmQ@mail.gmail.com>
 <d88999d8e9ec486bb1a0f75911457985@AcuMS.aculab.com> <CAG48ez3UO03RRMxxj-ZAcw5vhjhPYeoN1DB82s2SAiYm-qWmYw@mail.gmail.com>
In-Reply-To: <CAG48ez3UO03RRMxxj-ZAcw5vhjhPYeoN1DB82s2SAiYm-qWmYw@mail.gmail.com>
From: Seth Jenkins <sethjenkins@google.com>
Date: Wed, 9 Nov 2022 10:59:07 -0500
Message-ID: <CALxfFW4RQmLf9QRdP8VUH0fZU_vUsCqXfxRtjeu6g7QvKAGOmQ@mail.gmail.com>
Subject: Re: [PATCH] exit: Put an upper limit on how often we can oops
To: Jann Horn <jannh@google.com>
Cc: David Laight <David.Laight@aculab.com>, Kees Cook <keescook@chromium.org>, 
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, 
	Linus Torvalds <torvalds@linuxfoundation.org>, "Eric W . Biederman" <ebiederm@xmission.com>, 
	Andy Lutomirski <luto@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I'll add to this by noting that it is highly oops dependent. Depending
on what locks and refcounts you had taken at the moment you oops'd, it
may not be possible to clean up the process e.g. if you're holding
your own mmap lock at the moment you oops you're liable to deadlock in
__mmput. But there are certainly empirical cases (not all too isolated
ones) where the kernel really *is* able to clean up the entire
process.
