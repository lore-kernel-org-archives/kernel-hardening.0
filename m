Return-Path: <kernel-hardening-return-22011-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id AB2F8CD5BB1
	for <kernel-hardening@archiver.kernel.org>; Tue, 26 May 2026 17:05:08 +0000 (UTC)
Received: (qmail 10226 invoked by uid 550); 26 May 2026 17:04:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31962 invoked from network); 26 May 2026 12:16:05 -0000
ARC-Seal: i=1; a=rsa-sha256; t=1779797756; cv=none;
        d=google.com; s=arc-20240605;
        b=KXqcuXA4aWsCdUNuYRZP+IY2pP1vE4asbUbW4CH4J6OQ5QIzjwt4n0na4mygRQ1MaH
         OMeNKemNocga0xo3IWBUjbdIEp70ABt8xFwK0lay3e3DTnjbMzkYQpYy2+hazL7ZuI0T
         OiaLOZwHlvYWhRYlomD7xlv1XX6vcBjd3KlBnNqK0++liQZ4tQpB/jLOt9L90KwmPNzU
         C76eM5IUMrh+vDKWytDWeZ7sttQ4rYmZrCLnmzWVEA2xC5IKiXi1Dpv5G3rX/znTrw4t
         MBCx3+2wO2XOHuZxl8mHBtlJjJ68Xz7bN0G3gkcRIAC3ho/lj6UNF8TFWd0xdraq/o9B
         8yPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=1R5vcjxaZRslmeias0lTEwzcRstkb+ZVO+pzgqbDYco=;
        fh=tWJSxjWSHE0YDQlC2238e2dFwJcspntunCq8Jm0udcc=;
        b=lizDQFPm/1wTpVr0WpUNHDCFzyUKOdN8/nZs/tS9cP1EuBkONHqZBDIhDAw0fLsyJg
         EG+aFHfjm3b05ooixToq/fm1eAAYgZSJ9C4L1TfBfqXvpxqSSETxmrk6SHiVM3YSbPlP
         pkSkZ8/bCDoMoV1Yt1nnExiYUuKoxaBhUsoruxSPjb4g0fdaouPLa0LHtyK+MAatoZRH
         WOUu3qDArjk+3ho7amal4A/OCpzJJh257IyZrHEDqOU1ST7QUX0xYfGD0Jm4Dh6Tvy8j
         L7QemC3iUltxfxigVm95i6x6MCi3k/lVsvzIrO4toaaiQRhSwbgNKTiRbt9Wt9owFwgv
         iafQ==;
        darn=lists.openwall.com
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779797756; x=1780402556; darn=lists.openwall.com;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1R5vcjxaZRslmeias0lTEwzcRstkb+ZVO+pzgqbDYco=;
        b=ppgGVfCV1eH8CwRi8HXAO16nu79xtya+uKcj2FEQzpdUvMUp52MJfRNda1q+Tc61/k
         8T1Y8vvFn+Gg5y+ObklEP8Z9ZzuZREChNJXIWG/wIRi2R1+pQp34GpXOOlMKkEGH2fBz
         eGA8iSf8fmNJKCz+q6/7n+PT7IQ6D07gugPFjk9UFHksn6QdRcCuL1yhEa/sBgBKfnyo
         1mYpAa//U9zGtRWIXjgaAUmYzV3hlPomEc0Sjvp2B/OvXmbyk7QGEAxu1kuHG/NHzQX/
         NZPKSIKmih/qsDFVeuV1cIKPDqvqRJDugx4hAdL+FtGaPWgzZDfsU5lLwCCHIYBjctlB
         riww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779797756; x=1780402556;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1R5vcjxaZRslmeias0lTEwzcRstkb+ZVO+pzgqbDYco=;
        b=ROaTq1w2GAizHwf491OYP8DRAB2Z5nxb8y4fQPlAZKImd+QGLg36NKBX8fmpF0Q6SQ
         PFAAkaWVWm0lR2XKcqIoANsy4Ec3rpN8vr8f1mtX9h0jls+59BodWpaKpRNdsQoPRcwm
         W7p0K3NRgVyf02c0hSGLac/XCnA8zHE0jBupSDd+ivEyy0LA1w7cnjhoKE3V3Oxlrhwo
         XENm3oCge7B+Xi0zuZJVlftyL3RsNqumwlXTob1hg8lnXOFsZkkg8zN2U8bJNvZh8GzM
         kBhNr/catekC0RBHJPvkfY/SYD5F09p2408yZaIBkpLObmbxf5lPNQr3jqcfBOuYWT3Y
         6Psg==
X-Forwarded-Encrypted: i=1; AFNElJ8vKnJ185H46vEpWvLg3I471ldHvQ8HWwjzJuAe4A63B/YtKLW9oNHGIW/V7QgU7JRw+kXB3KC2H7vJyZLGDnG4@lists.openwall.com
X-Gm-Message-State: AOJu0YyANfPvu84CNpGVXfBuePUWQlG3e6Dd2Iba0Vf4YVKNoiiIl9qZ
	8WXc7YC2xGuC+v27vkgxohC0V+yok+TG5tuDK5wAaPifOUZSYSfQ2fQx6HPzRt7BbnDvTwiHmsu
	HX7wfkVIFzYGp3JrGaskqfnnO9MxZDGUyappR
X-Gm-Gg: Acq92OEkbRqsmlMf0X+wOx6VWwJRzrF/NRsMwAxvbfx2CPYkqoDC3eFSfz4xn0BScYH
	+tk3Cw2T41uDe7x+qp/5DW5bj5BWOirO4lDFf1WsWRuVT0S6dgNKsrXZkbfd8qax9VW13lSiDrr
	v/Xn4RNPUrNIw6Fm6Sn7cGg3zyoPzB+jstjc3s0XPDpKwZwHAXvRN97jD8Wa4WaSyCQMUHtkUnr
	qh0dMkWjNv0GEiG74KUs7bJhR1SDFrSzbsjy4cxAgEduTbEJ72zMVwrpbXzo6muMQQfCaVZ2R2w
	3WjV
X-Received: by 2002:a05:6402:5110:b0:66a:19bd:5cb8 with SMTP id
 4fb4d7f45d1cf-6889c85883emr9385734a12.18.1779797755754; Tue, 26 May 2026
 05:15:55 -0700 (PDT)
MIME-Version: 1.0
From: Ahmad Hasan <ahmaaaaadbntaaaaa@gmail.com>
Date: Tue, 26 May 2026 15:15:43 +0300
X-Gm-Features: AVHnY4JfSnp5KYt4Qam_m2WLoc5L_LIkSRVouQf8iskWBNwSWhBWXlLPgBelDD4
Message-ID: <CAAmtCfMS8+msHfKRBfECa4GDh0z9RnLx3Cmvf8hGdmGruziWkg@mail.gmail.com>
Subject: =?UTF-8?Q?TID_Protocol_=E2=80=94_Hardware=2DLevel_Cache_Security_Resea?=
	=?UTF-8?Q?rch_=7C_Website_Now_Live?=
To: amd-security@amd.com, kernel-hardening@lists.openwall.com
Content-Type: multipart/alternative; boundary="00000000000000fbcc0652b77508"

--00000000000000fbcc0652b77508
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Research Team,
My name is Ahmad Hasan, an independent security researcher from Jordan.
I am reaching out regarding TID (The Instant Destroyer) =E2=80=94 a Linux k=
ernel
module that addresses a critical gap: no existing security library flushes
CPU cache after wiping sensitive data, leaving cryptographic keys
recoverable through Flush+Reload attacks.
The project is now fully documented and publicly accessible:
=F0=9F=8C=90 Website: https://dot-name-1--aahmadbnt12345.replit.app
=F0=9F=92=BB GitHub:
https://github.com/ahmaaaaadbntaaaaa-byte/TID-The-Instant-Destroyer
=F0=9F=93=84 DOI: https://doi.org/10.5281/zenodo.17585929
The website includes full technical documentation, benchmarks, attack
simulation results, and installation guide.
I would welcome the opportunity to discuss a potential collaboration.
Best regards,
Ahmad Qasim Mohammad Hassan
ahmaaaaadbntaaaaa@gmail.com
ORCID: https://orcid.org/0009-0001-4360-0802

--00000000000000fbcc0652b77508
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><br><div dir=3D"auto">Dear Research Team,</div><div dir=
=3D"auto">My name is Ahmad Hasan, an independent security researcher from J=
ordan.</div><div dir=3D"auto">I am reaching out regarding TID (The Instant =
Destroyer) =E2=80=94 a Linux kernel module that addresses a critical gap: n=
o existing security library flushes CPU cache after wiping sensitive data, =
leaving cryptographic keys recoverable through Flush+Reload attacks.</div><=
div dir=3D"auto">The project is now fully documented and publicly accessibl=
e:</div><div dir=3D"auto">=F0=9F=8C=90 Website: <a href=3D"https://dot-name=
-1--aahmadbnt12345.replit.app">https://dot-name-1--aahmadbnt12345.replit.ap=
p</a></div><div dir=3D"auto">=F0=9F=92=BB GitHub: <a href=3D"https://github=
.com/ahmaaaaadbntaaaaa-byte/TID-The-Instant-Destroyer">https://github.com/a=
hmaaaaadbntaaaaa-byte/TID-The-Instant-Destroyer</a></div><div dir=3D"auto">=
=F0=9F=93=84 DOI: <a href=3D"https://doi.org/10.5281/zenodo.17585929">https=
://doi.org/10.5281/zenodo.17585929</a></div><div dir=3D"auto">The website i=
ncludes full technical documentation, benchmarks, attack simulation results=
, and installation guide.</div><div dir=3D"auto">I would welcome the opport=
unity to discuss a potential collaboration.</div><div dir=3D"auto">Best reg=
ards,</div><div dir=3D"auto">Ahmad Qasim Mohammad Hassan</div><div dir=3D"a=
uto"><a href=3D"mailto:ahmaaaaadbntaaaaa@gmail.com">ahmaaaaadbntaaaaa@gmail=
.com</a></div><div dir=3D"auto">ORCID: <a href=3D"https://orcid.org/0009-00=
01-4360-0802">https://orcid.org/0009-0001-4360-0802</a></div></div>

--00000000000000fbcc0652b77508--
