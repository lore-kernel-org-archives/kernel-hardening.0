Return-Path: <kernel-hardening-return-21551-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id EDAD0C433EF
	for <kernel-hardening@archiver.kernel.org>; Sat, 19 Mar 2022 12:13:14 +0000 (UTC)
Received: (qmail 15435 invoked by uid 550); 19 Mar 2022 12:13:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13849 invoked from network); 19 Mar 2022 12:10:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=sdeJyx83K3lPLVc496VLDfBIQyJhPzjAW0FyOcnIdls=;
        b=N9ZACpk3BgTaoUzESeEFnqFMhRO478KDS/LJaMvyJ7ynaNF4va6qVzO8R5NeDZHEno
         zYPyx/+nrYGhtpqz7ZHygtRWW5rMJ2x+PTSmy16VZnV+kguWT+MfDejPIuDrs0DvHiOj
         D1RxvkdLkdi58dSDLOAD5kwN3Q25oQJWbF6LGxaMhA8fs+j64zphGQyKOCCeKMsNVf4o
         AZbmUkwOzSNbLJbiqQ7VrIEndeCYEEsa+mtBWOMCHNUrqv20mvbbVrxO009ncQs2jGQc
         TnsJEO0DIrdVi8ogZwm2mI7LYI9dbq8YUdiAGd6CFqgOFBA1LHnKai0y0/2ocigaaDIC
         fmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=sdeJyx83K3lPLVc496VLDfBIQyJhPzjAW0FyOcnIdls=;
        b=bn7+71CzWw2eChyHfeOydgZfqqXYJNGF3zhlQoIE1xwv4Tx3ixgtQCw1MCXmd+fJ0Z
         N7RVnCEAeY2NFJuC/XTIZjzNNt70i2611azqUaJ/InZIfS3wEOD2DqbywobZ1zj6JVwb
         3IGlbiA7YjpjEHXJVi8clTBBYDDEZqDBkfJg/xTaMbK1sNppejj9KwltfVgagYd9tclY
         W1OCLbNgC5CC+hW2+GJaLen9vAq346JMWakVc7gXGg/eLdCdKR2a8IGIIagE29naSRWt
         V81TvgxNu9t+/i5nteQYrCRxZa7dDffP9KLJMwgwylVLrcXc5iT5PTa0FososOQkRXre
         J7rg==
X-Gm-Message-State: AOAM533ISnWMueFsEzq587fNiZ4CD/SDFrASMmbyulU9ga5olQXh5RFM
	9HRqX359HyD34uj5YxaRpGa/+0ybyvhd5Lm3yqyz3xA9zYN42g==
X-Google-Smtp-Source: ABdhPJwMyiTwArSzPLl7HQdHAZ2OzlCKiB5a5Qj8dLen9Ky1FAzQ6SQsFVMsDVhpQ28q5aQL3xdp6Bp1dc8ywDUXfvg=
X-Received: by 2002:a25:f904:0:b0:628:a84d:a105 with SMTP id
 q4-20020a25f904000000b00628a84da105mr13704142ybe.53.1647691839547; Sat, 19
 Mar 2022 05:10:39 -0700 (PDT)
MIME-Version: 1.0
From: Derrick McKee <derrick.mckee@gmail.com>
Date: Sat, 19 Mar 2022 08:10:34 -0400
Message-ID: <CAJoBWHxmsWThoQXNXRfDwmT2z=iEtwPQMU1iVtTZdNmqaCCaeQ@mail.gmail.com>
Subject: CVE Proofs of Concept
To: kernel-hardening@lists.openwall.com
Cc: linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I am a Ph.D. student at Purdue University researching kernel
compartmentalization.  I am currently conducting evaluation for a
follow-up paper to one published at NDSS 22 titled 'Preventing Kernel
Hacks with HAKC' (see [1]).  We are interested in empirically
evaluating our compartmentalization policies by determining if targets
of exploits (which we refer to as exploit sinks) are placed in a
different compartment from code that accesses the target (which we
refer to as exploit sources).

To that end, we are looking for a set of kernel exploit proofs of
concept that we can execute and examine.  I realize such a set could
be sensitive, and I will follow all safety procedures in the handling
and execution of any PoC.  In lieu of a set of PoCs, are there any
statistics of kernel structures that are targeted by attackers?  I
would imagine, for example, that struct cred would be heavily
targeted, but how often and what other kernel structures are targeted
would be invaluable.  Thank you for any insight you might have.

[1] https://www.ndss-symposium.org/ndss2022/accepted-papers/


-- 
Derrick McKee
Phone: (703) 957-9362
Email: derrick.mckee@gmail.com
