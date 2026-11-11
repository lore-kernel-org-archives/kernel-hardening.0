Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 347EA606A333
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Nov 2026 06:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kjb.biglobe.ne.jp header.i=@kjb.biglobe.ne.jp header.a=rsa-sha256 header.s=default-1th84yt82rvi header.b=PSiQG0mr
Received: (qmail 1223 invoked by uid 550); 11 Nov 2026 06:46:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1130 invoked from network); 11 Nov 2026 06:46:44 -0000
Message-ID: <3112e2ab6a83489fa82982253bf6779005d7b375.camel@kjb.biglobe.ne.jp>
Subject: RFC v3 Case Study Verification Results and Request for
 Reconsideration
From: Nakashima Seiichi <s-nakashima@kjb.biglobe.ne.jp>
To: kernel-hardening@lists.openwall.com, 
	linux-security-module@vger.kernel.org
Date: Wed, 11 Nov 2026 15:46:31 +0900
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Biglobe-Sender: s-nakashima@kjb.biglobe.ne.jp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kjb.biglobe.ne.jp; s=default-1th84yt82rvi; t=1794379592;
 bh=uFcDDhURneTkoucrRv/+cXRAgeX4hejcf0akWIaCJEM=;
 h=Subject:From:To:Date;
 b=PSiQG0mrZJFZJBuIO0g8LOnAFOvUYx/KGEcdDCBWgTnJ2b+RELiTe83EX+9KFQsvfix2o5Hj
 GRy0zr6fi0pV0wmspL78u6s3Ya5fqEzMwofkDMybO715yGpmFACNEkWPJcymPX3dN+fhZI2oz+
 E2e9FS+U6dpwUYBaUMPGlDkABtc+s7wkJI4rmf8LY4H9G79lxmqbOjyh2FqZIL4OFTC4J1Yhth
 1sf/3L+hrdgvl1LKKDTuabWUDB8Fia+9qhfrytN8efYlWJt4s2Fp4AmF4m59ozq5FP3SLUla3l
 qkHWRTWYPimASKsmYkOY0Gi+2kB4GjTeVi7ao9dHps0T4+kA==
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Dear ML,

Thank you for comments.

I actually tried creating the environment and running the case study,
but I realized it's quite difficult. Even just verifying this operation
was difficult for me alone, so I needed help from AI.

I would like to share the results of the RFC v3 case study verification
tests.
The test environment was Linux Mint 22.3 (based on Ubuntu 24.04 LTS)
with kernel 7.0.0-42-generic. The versions of the tools and libraries
used were as follows:

BPF LSM: enabled (bpf is present in the LSM list)
Tetragon: v1.1.0
seccomp-bpf: libseccomp 2.5.5

The target of the tests was CVE-2024-0582 (io_uring mitigation
techniques).
To get straight to the point, the assumptions we made in v3 turned out
to have many practical implementation difficulties, and I believe we
need to pause and reconsider our approach.
Specifically, the following points were identified:

1.BPF LSM-based blocking was not achievable on kernel 7.0.0 because the
io_uring-specific LSM hooks do not exist in this version. Detection is
possible, but blocking is not.

2.Tetragon v1.1.0 is incompatible with kernel 7.0.0 and failed at the
BPF object loading stage.

3.seccomp-bpf blocking was successful, but it is only effective on a
per-process basis.

4.During the tests, numerous implementation barriers were encountered,
including kernel symbol differences, missing tracepoint structures in
vmlinux.h, and bpftool virtual package issues.


Based on these results, the core claim of v3, that "it is technically
possible but not operationally scalable," was verified. However, the
effectiveness of BPF LSM and Tetragon depends heavily on the kernel and
tool versions, making practical deployment in the field difficult in
the current state.
I believe we should clarify the prerequisites and better define the
conditions for each technique before proceeding with further
discussion. I would appreciate your thoughts.

Best regards,

Nakashima Seiichi
