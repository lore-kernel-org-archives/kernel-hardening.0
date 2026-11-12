Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 19128606A321
	for <kernel-hardening@archiver.kernel.org>; Thu, 12 Nov 2026 07:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kjb.biglobe.ne.jp header.i=@kjb.biglobe.ne.jp header.a=rsa-sha256 header.s=default-1th84yt82rvi header.b=oPhG6uOa
Received: (qmail 28092 invoked by uid 550); 12 Nov 2026 07:06:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28012 invoked from network); 12 Nov 2026 07:06:09 -0000
Message-ID: <354cfbd5cfa9f1728a19acf33bd6d7409eb60059.camel@kjb.biglobe.ne.jp>
Subject: [RFC][IDEA] External Monitoring of Kernel Network Stack via BPF
 kprobe (KAF v2/v3 withdrawn)
From: Nakashima Seiichi <s-nakashima@kjb.biglobe.ne.jp>
To: kernel-hardening@lists.openwall.com, 
	linux-security-module@lists.linux.dev
Cc: keescook@chromium.org, paul@paul-moore.com, mic@digikod.net
Date: Thu, 12 Nov 2026 16:05:56 +0900
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Biglobe-Sender: s-nakashima@kjb.biglobe.ne.jp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kjb.biglobe.ne.jp; s=default-1th84yt82rvi; t=1794467157;
 bh=cGo5KqXZKQTNVwBRiuTlBQClomBdTZ//pXP2A+UvUhw=;
 h=Subject:From:To:Cc:Date;
 b=oPhG6uOaD76M0mOIW47l7bhfDExicQ3qRUVilagdBoq0sOijHYSCxLl6x+c+3xv2AeWqyz9m
 wXPWlLrlnJ6/ZhmjjG/p3J66Tt5sw3sK6DaUqYyRQaNu2RpCTHg/E2z7SuZmChlDiyaSwZYww9
 gXmDpUazyEhU8lMqXU3Aoh04f1mcRiR2EMWlEv/mw53E2tEoZ7zB5I3PrTluadk5tMX6JXHQq6
 4dXmqXfqcHyMrijLPD4+RZjWdyA8rILEdbJhq85zf2AhlyOsGXMbjV2b2EhubzNsC55H9Mg0kB
 p7288Q8Wt0vDYG2dA53S6vHTlqzJTB6xGStcwvOcK4pjNw2w==
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Dear ML,

I withdraw the KAF (Kernel API Firewall) v2/v3 proposals.
Instead, I am re-posting the results of my BPF kprobe-based
interception and monitoring experiments on the kernel network stack
as a new RFC idea.


=3D=3D Background and Motivation =3D=3D

In the original RFC idea, I assumed hooking kernel API calls inside
the kernel and embedding a mechanism to detect and block invalid
parameters or abnormal call patterns within the kernel itself.

However, experiments with bpftrace revealed that function calls
inside the kernel and metadata from structures such as struct sk_buff
can be traced from outside the kernel. This suggests that anomaly
detection and defense logic may be realized as an external process,
without modifying the kernel itself.


=3D=3D Test Environment =3D=3D

The following environment was built and used for this verification.

  Host OS          : Linux Mint 22.3
  Host Kernel      : 7.0.0-43-generic
  Virtualization   : KVM (QEMU)
  Guest OS         : Ubuntu 26.04
  Guest Kernel     : 7.0.0-43-generic
  BPF toolchain    : clang, bpftool v7.7.0, libbpf v1.7
  Test target      : CVE-2026-99999 (virtual checksum validation
scenario)

A KVM environment was built on the Host, and BPF program compilation,
loading, and operation were verified on the Guest Ubuntu.
The Guest kernel is the same as the Host (7.0.0-43-generic) and
runs with BTF (BPF Type Format) information enabled.


=3D=3D Experiment Flow and Verified Items =3D=3D

To verify this possibility, I conducted a step-by-step investigation
from proof-of-concept with bpftrace to a full BPF program using
libbpf/CO-RE.

=3D=3D=3D 1. Proof-of-concept with bpftrace =3D=3D=3D

  - Confirmed attachment to kprobe:__skb_checksum_complete
  - Confirmed reading of basic struct sk_buff fields (len, protocol,
    csum_start, csum_offset, etc.)
  - Confirmed difficulty of accessing the bit-field (ip_summed)
  - Confirmed limitations of bpf_override_return()

At this stage, I realized that kernel-internal processing could be
tracked and intercepted from the outside, and moved on to a more
complete implementation.

=3D=3D=3D 2. Full implementation with libbpf/CO-RE =3D=3D=3D

Experiments were conducted on the Guest with the following structure.

  - csum_guard_kprobe.c : BPF kernel program (kprobe + ringbuf)
  - load_kprobe.c       : User-space loader (using CO-RE skeleton)
  - common.h            : Event structure shared between BPF and user-
space
  - vmlinux.h           : Kernel structure header generated from BTF

=3D=3D=3D 3. Technically confirmed feasibility =3D=3D=3D

  BPF kprobe-based network stack interception         : Confirmed
  CO-RE reading of struct sk_buff fields              : Confirmed
  Bit-field reading                                   : Confirmed via
__builtin_preserve_field_info()
  BPF -> user-space communication via ringbuf         : Confirmed
  Loader structure using libbpf skeleton              : Confirmed

=3D=3D=3D 4. Key technical issues resolved =3D=3D=3D

  Bit-field reading :
    Resolved the problem that BPF_CORE_READ() cannot be used for
    sk_buff->ip_summed (__u8 ip_summed: 2) by obtaining the offset,
    size, and shift amount with __builtin_preserve_field_info() and
    reading with bpf_core_read().

  Structure sharing :
    Eliminated inconsistency by sharing struct event between the BPF
    side and the user-space side as common.h.

  Skeleton function names :
    Adapted to the prefix rules of bpftool gen skeleton.

  GPL license :
    bpf_probe_read_kernel() is GPL-only, so SEC("license") =3D "GPL"
    is mandatory.

  Ringbuf reference management :
    Memory reserved with bpf_ringbuf_reserve() must always be
    released with bpf_ringbuf_submit().


=3D=3D Current Limitations and Future Work =3D=3D

  Hook point :
    On kernel 7.0, __skb_checksum_complete is likely on the kprobe
    blacklist (or is a hot path that cannot be attached), so
    tcp_v4_rcv is currently used as the hook point for verification.
    Selecting an appropriate hook point at checksum validation time
    remains future work.

  Timing :
    tcp_v4_rcv is the packet receive entry point, and csum_start/
    csum_offset may still be in the middle of initialization, making
    it unsuitable as a checksum validation timing. Future work will
    consider attachment to more appropriate functions.

  Return value override :
    Faking the validation result with bpf_override_return() depends
    on attaching to an appropriate function.


=3D=3D About the Author and Acknowledgments =3D=3D

The proposer of this RFC idea is not a professional developer.
Most of the technical implementation and analysis in this
verification, including BPF program code creation, compilation error
analysis, bit-field reading method investigation, and libbpf/CO-RE
skeleton coordination, was carried out with the assistance of the
AI assistant Namazu provided by Sakana AI.

Please note that this proposal explores the feasibility of the idea
of "external monitoring of kernel security," and that the
implementation details were verified with AI assistance.


=3D=3D Conclusion =3D=3D

This RFC idea suggests that processing targeting kernel
vulnerabilities may be embedded as an external process, rather than
inside the kernel itself.

Using the combination of BPF kprobe + CO-RE + ringbuf, we
successfully operated a mechanism to monitor and record metadata
from inside the kernel's network stack from the outside, and to
detect anomalies on kernel 7.0. We believe this opens a path to
dynamically realizing security monitoring and anomaly detection
without applying kernel patches or loading kernel modules.

I would like the core security members to discuss the feasibility
of this approach in depth.


KAF v2/v3 are withdrawn and this is re-posted as an RFC idea.


=3D=3D Appendix: About CVE-2026-99999 =3D=3D

The CVE-2026-99999 mentioned is a virtual vulnerability scenario used
for this verification. It is not an actual CVE, but a test case
assuming an attack exploiting a checksum validation flaw. If
extending this to verification against an actual vulnerability,
adjustments tailored to the details of the target CVE will be
required.

Nakashima Seiichi
