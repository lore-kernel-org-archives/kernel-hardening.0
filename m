Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 79468606A339
	for <kernel-hardening@archiver.kernel.org>; Thu, 12 Nov 2026 19:30:09 +0000 (UTC)
Received: (qmail 15821 invoked by uid 550); 12 Nov 2026 19:21:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29966 invoked from network); 12 Nov 2026 16:42:59 -0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Thu, 12 Nov 2026 16:05:34 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: RainLoop/1.14.0
From: "Marian Marinov" <hackman@yuhu.biz>
Message-ID: <8bcf9e92773fc1b5b4350bdb49e2bc60@yuhu.biz>
Subject: Re: [RFC][IDEA] External Monitoring of Kernel Network Stack via
 BPF kprobe (KAF v2/v3 withdrawn)
To: "Nakashima Seiichi" <s-nakashima@kjb.biglobe.ne.jp>,
 kernel-hardening@lists.openwall.com, linux-security-module@lists.linux.dev
Cc: keescook@chromium.org, paul@paul-moore.com, mic@digikod.net
In-Reply-To: <354cfbd5cfa9f1728a19acf33bd6d7409eb60059.camel@kjb.biglobe.ne.jp>
References: <354cfbd5cfa9f1728a19acf33bd6d7409eb60059.camel@kjb.biglobe.ne.jp>
X-Virus-Scanned: ClamAV using ClamSMTP
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Do you realize how slow this would be in a hot path in the kernel?=0A=0AP=
lease think this through. A network path on a 10G interface might process=
 millions of packets per second.=0AImplementing what you want will kill t=
he performance. Performance that is tightly optimized around CPU cache li=
nes.=0AWhat you are proposing will introduce slowness and change of cache=
 coherency that will have a heavy hit on performance. =0A=0AI think that =
we should allow the sysadmins to decide if they want to reduce their syst=
em performance for this kind of security measure. We already suffer some =
performance hit because of CPU mitigations and there is nothing the kerne=
l can do about it. =0A=0AAdditionally, most of the serious attack vectors=
 would require multiple things in the kernel to be monitored. =0AWe also =
know that slowing down some parts of the kernel might open other parts of=
 it to race condition attacks. =0A=0AMaybe we should focus more on educat=
ing people on how to handle these types of attacks with the tools we have=
 at our disposal at the moment.=0A=0AI really hope that this path you too=
k, thought you more about how the kernel and its security works, so you c=
an enhance your idea(s) in the future.=0A=0AI would also suggest that you=
 look at building this out-of-tree and getting some of your friends on bo=
ard. Obviously you are doing a lot of work with an LLM. Force it to build=
 the PoC for you. Show this as a viable option. =0A=0AAt the moment, pers=
onally, I think this proposal is just loosing the valuable time of the pe=
ople in these mailing lists. =0A=0AMarian=0A=0ANovember 12, 2026 2:05 AM,=
 "Nakashima Seiichi" <s-nakashima@kjb.biglobe.ne.jp> wrote:=0A=0A> Dear M=
L,=0A> =0A> I withdraw the KAF (Kernel API Firewall) v2/v3 proposals.=0A>=
 Instead, I am re-posting the results of my BPF kprobe-based=0A> intercep=
tion and monitoring experiments on the kernel network stack=0A> as a new =
RFC idea.=0A> =0A> =3D=3D Background and Motivation =3D=3D=0A> =0A> In th=
e original RFC idea, I assumed hooking kernel API calls inside=0A> the ke=
rnel and embedding a mechanism to detect and block invalid=0A> parameters=
 or abnormal call patterns within the kernel itself.=0A> =0A> However, ex=
periments with bpftrace revealed that function calls=0A> inside the kerne=
l and metadata from structures such as struct sk_buff=0A> can be traced f=
rom outside the kernel. This suggests that anomaly=0A> detection and defe=
nse logic may be realized as an external process,=0A> without modifying t=
he kernel itself.=0A> =0A> =3D=3D Test Environment =3D=3D=0A> =0A> The fo=
llowing environment was built and used for this verification.=0A> =0A> Ho=
st OS : Linux Mint 22.3=0A> Host Kernel : 7.0.0-43-generic=0A> Virtualiza=
tion : KVM (QEMU)=0A> Guest OS : Ubuntu 26.04=0A> Guest Kernel : 7.0.0-43=
-generic=0A> BPF toolchain : clang, bpftool v7.7.0, libbpf v1.7=0A> Test =
target : CVE-2026-99999 (virtual checksum validation=0A> scenario)=0A> =
=0A> A KVM environment was built on the Host, and BPF program compilation=
,=0A> loading, and operation were verified on the Guest Ubuntu.=0A> The G=
uest kernel is the same as the Host (7.0.0-43-generic) and=0A> runs with =
BTF (BPF Type Format) information enabled.=0A> =0A> =3D=3D Experiment Flo=
w and Verified Items =3D=3D=0A> =0A> To verify this possibility, I conduc=
ted a step-by-step investigation=0A> from proof-of-concept with bpftrace =
to a full BPF program using=0A> libbpf/CO-RE.=0A> =0A> =3D=3D=3D 1. Proof=
-of-concept with bpftrace =3D=3D=3D=0A> =0A> - Confirmed attachment to kp=
robe:__skb_checksum_complete=0A> - Confirmed reading of basic struct sk_b=
uff fields (len, protocol,=0A> csum_start, csum_offset, etc.)=0A> - Confi=
rmed difficulty of accessing the bit-field (ip_summed)=0A> - Confirmed li=
mitations of bpf_override_return()=0A> =0A> At this stage, I realized tha=
t kernel-internal processing could be=0A> tracked and intercepted from th=
e outside, and moved on to a more=0A> complete implementation.=0A> =0A> =
=3D=3D=3D 2. Full implementation with libbpf/CO-RE =3D=3D=3D=0A> =0A> Exp=
eriments were conducted on the Guest with the following structure.=0A> =
=0A> - csum_guard_kprobe.c : BPF kernel program (kprobe + ringbuf)=0A> - =
load_kprobe.c : User-space loader (using CO-RE skeleton)=0A> - common.h :=
 Event structure shared between BPF and user-=0A> space=0A> - vmlinux.h :=
 Kernel structure header generated from BTF=0A> =0A> =3D=3D=3D 3. Technic=
ally confirmed feasibility =3D=3D=3D=0A> =0A> BPF kprobe-based network st=
ack interception : Confirmed=0A> CO-RE reading of struct sk_buff fields :=
 Confirmed=0A> Bit-field reading : Confirmed via=0A> __builtin_preserve_f=
ield_info()=0A> BPF -> user-space communication via ringbuf : Confirmed=
=0A> Loader structure using libbpf skeleton : Confirmed=0A> =0A> =3D=3D=
=3D 4. Key technical issues resolved =3D=3D=3D=0A> =0A> Bit-field reading=
 :=0A> Resolved the problem that BPF_CORE_READ() cannot be used for=0A> s=
k_buff->ip_summed (__u8 ip_summed: 2) by obtaining the offset,=0A> size, =
and shift amount with __builtin_preserve_field_info() and=0A> reading wit=
h bpf_core_read().=0A> =0A> Structure sharing :=0A> Eliminated inconsiste=
ncy by sharing struct event between the BPF=0A> side and the user-space s=
ide as common.h.=0A> =0A> Skeleton function names :=0A> Adapted to the pr=
efix rules of bpftool gen skeleton.=0A> =0A> GPL license :=0A> bpf_probe_=
read_kernel() is GPL-only, so SEC("license") =3D "GPL"=0A> is mandatory.=
=0A> =0A> Ringbuf reference management :=0A> Memory reserved with bpf_rin=
gbuf_reserve() must always be=0A> released with bpf_ringbuf_submit().=0A>=
 =0A> =3D=3D Current Limitations and Future Work =3D=3D=0A> =0A> Hook poi=
nt :=0A> On kernel 7.0, __skb_checksum_complete is likely on the kprobe=
=0A> blacklist (or is a hot path that cannot be attached), so=0A> tcp_v4_=
rcv is currently used as the hook point for verification.=0A> Selecting a=
n appropriate hook point at checksum validation time=0A> remains future w=
ork.=0A> =0A> Timing :=0A> tcp_v4_rcv is the packet receive entry point, =
and csum_start/=0A> csum_offset may still be in the middle of initializat=
ion, making=0A> it unsuitable as a checksum validation timing. Future wor=
k will=0A> consider attachment to more appropriate functions.=0A> =0A> Re=
turn value override :=0A> Faking the validation result with bpf_override_=
return() depends=0A> on attaching to an appropriate function.=0A> =0A> =
=3D=3D About the Author and Acknowledgments =3D=3D=0A> =0A> The proposer =
of this RFC idea is not a professional developer.=0A> Most of the technic=
al implementation and analysis in this=0A> verification, including BPF pr=
ogram code creation, compilation error=0A> analysis, bit-field reading me=
thod investigation, and libbpf/CO-RE=0A> skeleton coordination, was carri=
ed out with the assistance of the=0A> AI assistant Namazu provided by Sak=
ana AI.=0A> =0A> Please note that this proposal explores the feasibility =
of the idea=0A> of "external monitoring of kernel security," and that the=
=0A> implementation details were verified with AI assistance.=0A> =0A> =
=3D=3D Conclusion =3D=3D=0A> =0A> This RFC idea suggests that processing =
targeting kernel=0A> vulnerabilities may be embedded as an external proce=
ss, rather than=0A> inside the kernel itself.=0A> =0A> Using the combinat=
ion of BPF kprobe + CO-RE + ringbuf, we=0A> successfully operated a mecha=
nism to monitor and record metadata=0A> from inside the kernel's network =
stack from the outside, and to=0A> detect anomalies on kernel 7.0. We bel=
ieve this opens a path to=0A> dynamically realizing security monitoring a=
nd anomaly detection=0A> without applying kernel patches or loading kerne=
l modules.=0A> =0A> I would like the core security members to discuss the=
 feasibility=0A> of this approach in depth.=0A> =0A> KAF v2/v3 are withdr=
awn and this is re-posted as an RFC idea.=0A> =0A> =3D=3D Appendix: About=
 CVE-2026-99999 =3D=3D=0A> =0A> The CVE-2026-99999 mentioned is a virtual=
 vulnerability scenario used=0A> for this verification. It is not an actu=
al CVE, but a test case=0A> assuming an attack exploiting a checksum vali=
dation flaw. If=0A> extending this to verification against an actual vuln=
erability,=0A> adjustments tailored to the details of the target CVE will=
 be=0A> required.=0A> =0A> Nakashima Seiichi
