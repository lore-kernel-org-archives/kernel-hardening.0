Return-Path: <kernel-hardening-return-21574-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 04302C433FE
	for <kernel-hardening@archiver.kernel.org>; Sun,  9 Oct 2022 12:21:01 +0000 (UTC)
Received: (qmail 8074 invoked by uid 550); 9 Oct 2022 12:20:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5447 invoked from network); 9 Oct 2022 06:32:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vSk0hKn25FgEiklfFGzsu2I4jcIOoz7J5cFwKLYvUgQ=;
        b=nLcZ5h0RS5hfkUnnyYgnp2Ht+s5+sleB5iMtr77N6+fC1MMlIOdt2w7bjMvu1ZB2nD
         3QZJKEiT5pwzLXN3cDoCLJ2sYPfCs8IA4q6DfV/pYd0QnD+pBciqUhDqBTMG3NMFtjmY
         7cbB8B67PE15QhZ0Mx2UpO5KSF8ou0vztWmliF7Rs9lHwvHjuW9ZxbvBcHexm1/BIH2s
         hGgbrs5sXaBszpVaJiM1t+8DTDc8NRH7xD+ZK5DLYI7spw2OhBm1faR0qITUCQt1D6t6
         C4msxmI3xZvQcw67dzYWBGp3W0cTqy/QIyz4Jtjr1ItKqlVUq5tFQublpSyQCOhesybJ
         /sOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vSk0hKn25FgEiklfFGzsu2I4jcIOoz7J5cFwKLYvUgQ=;
        b=KLl+TU085RJnthRL6zjsdf+YyjZkMAAYf+FpGUpgDB8/bdxGLzMuhqSexnuanVXqPv
         d99rQXbbKYA49FszitkVKdE9UGbwVlGwAxQRwf61D12DS0thAtxJThQi9iWo0I4wQP+c
         EKYLiPKpZYvN63wdCExerElXPNjFBx8BpshMTsEDsoZg57hVwIDKPZ3x/vqDNl/j2Qul
         S1X/yP3wWYMwT18HF+mjkPJqvUAsBYg/jkS5OlvVmXX0F8iRegmd7CF/CZJvZQ8YfkSr
         dVEEd1upLm9/SmFOpmI/+I601e+7sj+cu3rEcQ6SXj8d2hz9x+o8gKxBntj3ynlu7FiB
         uZFA==
X-Gm-Message-State: ACrzQf3sA+GBxOPyfYcyPjZ8FxdN6w2Cs3qa7shCHGZClEUJG9+ZMNk0
	GLmafz3hDc6NIvc+qq1F2spcVMBsggSSxg==
X-Google-Smtp-Source: AMsMyM7jttaiGGuIu3iLh4AA4KMmCYzuy2Rz9XSOuuYTFoPZSVUs9g/VOY9cDyNAJRXvUZaiJoGKWw==
X-Received: by 2002:a17:90a:e7ce:b0:20a:c658:c183 with SMTP id kb14-20020a17090ae7ce00b0020ac658c183mr14301551pjb.5.1665297163548;
        Sat, 08 Oct 2022 23:32:43 -0700 (PDT)
Date: Sun, 9 Oct 2022 19:32:38 +1300
From: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: linux-hardening@vger.kernel.org
Subject: [Self-introduction] - Paulo Almeida
Message-ID: <Y0JrBsGthQIiSzp+@mail.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

My name is Paulo Almeida and as per the instructions listed on the KSPP
page, this is my self-introduction email :)

I will keep it short. 

- My background is in HPC and AI 
- I've been writing software for around 20 years now
- I've written my x86-64 hobbyist OS for fun and in my spare time I've
  writing a MOS 6502 emulator for the same reason.
- Contributing to KSPP is going to be a side project of mine that I plan
  to do outside of business hours... so expect a dedication of a few
  hours per week.

Q: What topics are you interested in?
A: kernel driver development, x86 & ARM hardware architecture, Math, Data
structures, Rust and virtualisation.

Q: What do you want to learn about?
A: I see the KSPP project/initiative as a way to get exposed to pieces
of code that I wouldn't normally come across which is always
appreciated :)

I am also aware of the calibre of developers I will be dealing with and
I'm sure that I will be learning really a lot from them :)

Q: What experience do you have with security, the kernel, programming, 
	or anything else you think is important.
A: 
I've contributed to the kernel a few times time in the past for both
adding features and janitorial tasks.

I took the Linux Kernel Internals (LF420) and the Linux Kernel Debugging
and Security (LF44) courses by the Linux Foundation.

As for other experiences, due to the fact that I wrote my hobbyist OS, I
do have a decent experience with the x86/x86-64 architecture. I also
spent quite sometime writing static analysis parsers.... so should those
experiences help anyone or any possible future plan for the KSPP, please
count on me.

Thanks!

Paulo Almeida

