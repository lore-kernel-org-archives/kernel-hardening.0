Return-Path: <kernel-hardening-return-22007-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id A68C6CD4F5B
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 May 2026 16:59:16 +0000 (UTC)
Received: (qmail 5627 invoked by uid 550); 19 May 2026 16:48:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5444 invoked from network); 19 May 2026 16:48:05 -0000
ARC-Seal: i=1; a=rsa-sha256; t=1779209275; cv=none;
        d=google.com; s=arc-20240605;
        b=VTAk/MHajuf7SMnmEfkXu2zuL17NdiGYoijxgZC6D+CEyq3K7wdzvnmTSiI4PjEndp
         1cK4j46O19ReInAOsUH8bWX2bAERQqKm8L3t+tGE83Ok0CBbqwTunb6TcZIjHlFqq3gX
         WsbpNLdhabxxzSi66JBDqpk8CrdJH2GsbVokEkWiA9rt8UudmbaCPMBxF8ONJTwAlzJm
         qAON8GRSvENemsmSKqE6PtUKSu9sviHd9XPfyBKlFHuxLYCtjKLHDePYQ8Vf8L1ocPkS
         kQqJi38ClOiUf5R2MGNkAPpcuq4b4m2E9P5x2C9mUOY5MRRmUyIPLVR+Pd7lTmZlqPCl
         sZ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ViKPE/zs4gsJozSFsoDM9rzZ64VredtJAzBJtyzJDD8=;
        fh=PWoUb6p5A4cs2U1azubJdfos7iX3OPdpbzgFgj62v1A=;
        b=WSeZoryK0xQYZDuOU+FkS1odRXopkA4weHdnqgvbwfqlN+KELFA8Dp2MBv9//T6uod
         Q3fB8vd8sevBAIr4/GUdIjSBU3rgTXXx601xN1shhL1Ujr3AUnBEEPdTI4ukoauUBk01
         Ohfqf2Fud6rfKR3VU+ezW8OgSqlxeRd51MQrUNnsVS3szp53zckfpdEkCiDeL5GvvyMm
         +GI0Vp58kRRcIz5fvnp/8MOHas3QmOzwJizPSI/dHILsx7iVd3p8n0At/BvnlFMx/IaT
         au1ftJyOMAycXSYh+ymOFCmbRmtWlq8TIQBndUf1HFEQoHA0O5TKP8XkE1EIlv2gds55
         UCvw==;
        darn=lists.openwall.com
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779209275; x=1779814075; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ViKPE/zs4gsJozSFsoDM9rzZ64VredtJAzBJtyzJDD8=;
        b=kphK1wbLfVLcc8SqQHZXq6LQrdvAU6CayxUSDQzkwqVFu4oZ6MMxwpc+Urv+ujn1Ab
         VN1JnlXjzNrJ3VdjXZSsVPBTrJob+hd8SAayIVN768ApaVrULDUmiInL8alDRlY4HSap
         r6XkKUOPfF9lpMY9vkoUA20IMrUkc0RzOHvXwN5Re8bwsB0qFHOZsCAPfecD19AX4I1B
         +gKgSLyg6MT7keHe8jdV6kZQPPiA/3ZqQTR2/3vRneiOgfw8Jf1N7whWTikr+4VVFJnG
         lrfCo+sgdkwHWsjD47pMlyJ11OhhwbZbTEILL8M2MekJ6/Ujf9GcDGuiwM1kUC1gPWEf
         77zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779209275; x=1779814075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ViKPE/zs4gsJozSFsoDM9rzZ64VredtJAzBJtyzJDD8=;
        b=eFx7jtgRTNbgJI1EX5njD2RH2lNeD5Z16vIEShvsPIjDNDCGqwpgWmB5BzJF1Zy0JM
         f0cRFi/thPk9eX7VsOwHhaWCQoXeW5Xmv2RQPjrPFfh1kNh/pBNTuw/BrWKoPuBH7uZF
         y92uIrVcnVpRd6WpKmMh1Hb75e5PcyL5RrFnZ1E4Q1PyVt6WLaBCwi5FsyfcuX6jbhLn
         z3+Kg+dsv9IE0iPz45OeJqnQ1F5g6FCQh4y4CRHLlZcUxvUBl522G35+bI+yNkc6xsYW
         pvd7KfSmHx62v64wTXH1bwvzMtjSHLgM84p3jo68uPylGgQ/hygJhu99g09XGYS0Tuih
         61Rg==
X-Forwarded-Encrypted: i=1; AFNElJ+Zg9hVZ17fZTe3Y07V0lQGr8Lgev5qmbfqdj4K8yamOjFXSkK3xKqDkDW9Hp/N3o5mGI2m/r1/gw1XojrE68tC@lists.openwall.com
X-Gm-Message-State: AOJu0YzlMSZgzW48n2gOWgXKZZQCSYECg8TTO/AX3G2pNZyvI9YWm+EP
	Iooe9xRVG8E6HLcoUxHIFRCxqWHrZiDaYCY8o+opah958XlbSdaaufMWsEfwzhEosrb8vOrLce5
	RSeaLdG8FcK5ucaHYX0ejpYT7X/VGXkocBr6SBZTiVTnGe8ldtKD2Gyc8
X-Gm-Gg: Acq92OHZD/66G9pQek1lcuiN+nn8bhh8LoZEP5iYGtDY1ayH3yfxMbynq0cExvOKFS3
	RWRHiaNqj1FOZ2LcA2rO4w58a2HFE8H72xYYnvw/SIPoPWDnINXGcD6/YlZ2o0ZJHoAVV12fowe
	TK+QBw7QbLeDUvuPO9fM9bw9kt1qvcdilp2YISBvip64N2f+/sl5kW9Ze80kjr6m7lh+IMomTh8
	gt/2/b6oVKx0p/5AVMvEXjlrXFYD+hZcIW7eCQ6WdohLo/EGf8UjNLrzvmbWJFBW5aN80v6VzLg
	e7Ija7NKuyMGad4BUwotIEYHRJu1NMbAALNb8yO0ybtn0Inv
X-Received: by 2002:a05:7022:41a3:b0:12c:2ed4:6314 with SMTP id
 a92af1059eb24-13557dcef85mr326451c88.1.1779209273823; Tue, 19 May 2026
 09:47:53 -0700 (PDT)
MIME-Version: 1.0
References: <F78521DA-08DC-424E-BBE1-231BC900CEE0@gmail.com>
In-Reply-To: <F78521DA-08DC-424E-BBE1-231BC900CEE0@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 19 May 2026 18:47:15 +0200
X-Gm-Features: AVHnY4LvG4Du5d39_T67NOwKnozMptM-y7xFRUTkKn7VXkYMQfWRo6DTkXiA7Lg
Message-ID: <CAG48ez0KsuR5z4RDgxWPUoS8e_MJzF74RgFDJayohG48A_N0PQ@mail.gmail.com>
Subject: Re: [RFC] TID v2.0: kernel module for cache-line zeroization against
 Flush+Reload (CLFLUSHOPT + LFENCE + REP STOSQ)
To: Ahmed Hassan <ahmaaaaadbntaaaaa@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com, 
	linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2026 at 11:47=E2=80=AFPM Ahmed Hassan
<ahmaaaaadbntaaaaa@gmail.com> wrote:
>
> Hi kernel developers,
>
> I am sharing TID (The Instant Destroyer) v2.0, a Linux kernel module
> written in C that addresses a specific gap in existing security
> libraries: none of them (libsodium, OpenSSL, glibc memzero_explicit)
> flush CPU cache lines after memory zeroization.
>
>
> =3D=3D Problem =3D=3D
>
> Standard zeroization functions (explicit_bzero, sodium_memzero,
> OPENSSL_cleanse) prevent the compiler from eliding the wipe, but do
> not evict CPU cache lines (L1/L2/L3). This leaves residual key
> material measurable via Flush+Reload (Yarom & Falkner, 2014) after
> data use ends.

The thing you're talking about isn't really related to the
Flush+Reload side channel attack, right? You're just talking about
flushing cache lines.

In what threat model would this be an issue? Normally, the goal of
memory zeroing is to ensure that sensitive data is wiped before an
attacker has a chance to physically pull out the RAM from a machine
and plug it into another device that can reveal RAM contents, or
before an attacker gains physical control of a locked device and can
connect malicious peripherals to it, or such.

So for this to be an actual security problem, the device would have to
keep running in a sufficiently high power state that data caches are
not discarded, and at the same time not perform enough memory accesses
to cause this memory to be discarded...

Assuming that this is an actual problem, why are you using a kernel
module for this? At least on x86, CLFLUSH is unprivileged, so crypto
libraries should be able to just use that directly. (There is the
caveat of what happens when the kernel migrates pages or kills a
process, but that's a larger problem.)
