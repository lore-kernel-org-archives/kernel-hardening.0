Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20120522173942.GJ11775@ZenIV.linux.org.uk>
References: <CACLa4puRJLUd6hAHO6zFYiqa5dFVum8eLmNMk_ef+=r8OGhjRg@mail.gmail.com>
	<CAB=4xho2b5fZV_jC15XW3mhOD9Z0QUMnV_UHy-P5EmQWfX59dA@mail.gmail.com>
	<5d6179f59222155b72d9aa9f171e883c.squirrel@webmail.greenhost.nl>
	<CABqD9hbzatHerMA1Nq57Qn8SKSZzZf=5t6aLumG9ZpAafgX=UQ@mail.gmail.com>
	<20120522173942.GJ11775@ZenIV.linux.org.uk>
Date: Tue, 22 May 2012 15:26:20 -0500
Message-ID: <CABqD9hbwnp-Kob0-Uc9L=qgJfS88po=RHNPkhQFcSf4RTrFCmQ@mail.gmail.com>
From: Will Drewry <wad@chromium.org>
Content-Type: multipart/mixed; boundary=f46d043bd6fadf412004c0a5d4f2
Subject: [kernel-hardening] Re: seccomp and ptrace. what is the correct order?
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Indan Zupancic <indan@nul.nu>, Roland McGrath <mcgrathr@google.com>, Eric Paris <netdev@parisplace.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

--f46d043bd6fadf412004c0a5d4f2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, May 22, 2012 at 12:39 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, May 22, 2012 at 11:23:06AM -0500, Will Drewry wrote:
>
>> However(!), if we did move secure_computing() to after ptrace _and_
>> added a check after SECCOMP_RET_TRACE's ptrace_event call, we could
>> ensure the system call was not changed by the tracer. =A0This would give
>> strong assurances that whatever system call is executed was explicitly
>> allowed by seccomp policy is the one that was executed.
>
> BTW, after grepping around a bit, I have to say that some callers of thos=
e
> hooks make very little sense

Yeah - the arch specific seccomp and ptrace code is in dire need of
attention on a number of platforms.

> Exhibit A: sh32 has in do_syscall_trace_enter(regs)
> =A0 =A0 =A0 =A0secure_computing(regs->regs[0]);
> Syscall number in r0, right?
> =A0 =A0 =A0 =A0[usual PTRACE_SYSCALL bits]
> =A0 =A0 =A0 =A0if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0trace_sys_enter(regs, regs->regs[0]);
> Ditto
> =A0 =A0 =A0 =A0audit_syscall_entry(audit_arch(), regs->regs[3],
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0regs->regs[4], reg=
s->regs[5],
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0regs->regs[6], reg=
s->regs[7]);
> Oops - that one says syscall number in r3, first 4 arguments in r4..r7
> =A0 =A0 =A0 =A0return ret ?: regs->regs[0];
>
> and the caller of that sucker is
> syscall_trace_entry:
> =A0 =A0 =A0 =A0! =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Yes it is tr=
aced.
> =A0 =A0 =A0 =A0mov =A0 =A0 r15, r4
> =A0 =A0 =A0 =A0mov.l =A0 7f, r11 =A0 =A0 =A0 =A0 ! Call do_syscall_trace_=
enter which notifies
> =A0 =A0 =A0 =A0jsr =A0 =A0 @r11 =A0 =A0 =A0 =A0 =A0 =A0! superior (will c=
homp R[0-7])
> =A0 =A0 =A0 =A0 nop
> =A0 =A0 =A0 =A0mov.l =A0 r0, @(OFF_R0,r15) =A0 =A0 =A0 ! Save return valu=
e
> =A0 =A0 =A0 =A0! =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Reload R0-R4=
 from kernel stack, where the
> =A0 =A0 =A0 =A0! =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 parent may h=
ave modified them using
> =A0 =A0 =A0 =A0! =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ptrace(POKEU=
SR). =A0(Note that R0-R2 are
> =A0 =A0 =A0 =A0! =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 used by the =
system call handler directly
> =A0 =A0 =A0 =A0! =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from the ker=
nel stack anyway, so don't need
> =A0 =A0 =A0 =A0! =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 to be reload=
ed here.) =A0This allows the parent
> =A0 =A0 =A0 =A0! =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 to rewrite s=
ystem calls and args on the fly.
> =A0 =A0 =A0 =A0mov.l =A0 @(OFF_R4,r15), r4 =A0 ! arg0
> =A0 =A0 =A0 =A0mov.l =A0 @(OFF_R5,r15), r5
> =A0 =A0 =A0 =A0mov.l =A0 @(OFF_R6,r15), r6
> =A0 =A0 =A0 =A0mov.l =A0 @(OFF_R7,r15), r7 =A0 ! arg3
> =A0 =A0 =A0 =A0mov.l =A0 @(OFF_R3,r15), r3 =A0 ! syscall_nr
> =A0 =A0 =A0 =A0!
> =A0 =A0 =A0 =A0mov.l =A0 2f, r10 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ! Number=
 of syscalls
> =A0 =A0 =A0 =A0cmp/hs =A0r10, r3
> =A0 =A0 =A0 =A0bf =A0 =A0 =A0syscall_call
> [...]
> 7: =A0 =A0 =A0.long =A0 do_syscall_trace_enter
>
> ... and syscall_call very clearly picks an index in syscall table from r3=
.
> Incidentally, r0 is the fifth syscall argument... =A0So what we have is
> =A0 =A0 =A0 =A0* b0rken hookups for seccomp and tracepoint
> =A0 =A0 =A0 =A0* b0rken cancelling of syscalls by ptrace (replacing sysca=
ll number
> with -1 would've worked; doing that to the 5th argument - not really)
>
> Exhibit B: sh64; makes even less sense, but there the assembler glue had
> been too dense for me to get through. =A0At the very least, seccomp and
> tracepoint are assuming that syscall number is in r9, while audit is
> assuming that it's in r1. =A0I'm not too inclined to trust audit in this
> case, though. =A0The _really_ interesting part is that by the look of
> their pt_regs syscall number is stored separately - not in regs->regs[]
> at all. =A0And the caller
> =A0 =A0 =A0 =A0* shoves the return value of do_syscall_trace_enter() into=
 regs->regs[2]
> =A0 =A0 =A0 =A0* picks syscall number from regs->syscall_nr and uses that=
 as index
> in sys_call_table
> =A0 =A0 =A0 =A0* seems to imply that arguments are in regs->regs[2..7]
> =A0 =A0 =A0 =A0* code around the (presumable) path leading there seems to=
 imply
> that syscall number comes from the trap number and isn't in regs->regs[]
> at all. =A0But I might be misreading that assembler. =A0Easily.
>
> Exhibit C:
> mips is consistent these days, but it has no tracepoint hookup *and* it d=
oes
> open-code tracehook_report_syscall_entry(), except for its return value..=
.
> Used to pass the wrong register to seccomp, IIRC.
>
> We really ought to look into merging those suckers. =A0It's a source of P=
ITA
> that keeps coming back; what we need is
> =A0 =A0 =A0 =A0regs_syscall_number(struct pt_regs *)
> =A0 =A0 =A0 =A0regs_syscall_arg1(struct pt_regs *)
> =A0 =A0 =A0 =A0...
> =A0 =A0 =A0 =A0regs_syscall_arg6(struct pt_regs *)
> in addition to existing
> =A0 =A0 =A0 =A0regs_return_value(struct pt_regs *)
> added on all platforms and made mandatory for new ones. =A0With that we
> could go a long way towards merging these implementations...

For fun, I took a stab at that to see how it'd play out for x86.
(Attached instead of inline since it's just a first cut.)

I do think much of the ptrace/seccomp could be merged, but I don't
know how quickly given all the changes that each arch will need.

What makes sense for the current seccomp work?  I'm not displeased
with the in-tree behavior, but the alternative approach would change
the ptrace+seccomp interactions (minimally) just by switching the
ordering.  It's not hard to change all the existing arches that call
secure_computing calls (I have a tentative patch set), but it wouldn't
fix their general brokenness.

Anyway, I'd like to see seccomp work properly on all arches, but if
there are strong opinions about the correct expectations between
seccomp and ptrace, I'm happy to fix that /now/ for whatever arches it
makes sense for.

thanks!
will

--f46d043bd6fadf412004c0a5d4f2
Content-Type: text/plain; charset=US-ASCII;
	name="0001-arch-x86-asm-generic-add-syscall_regs.h.patch.txt"
Content-Disposition: attachment;
	filename="0001-arch-x86-asm-generic-add-syscall_regs.h.patch.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h2je82wy0

RnJvbSBmMjgxZTE5NGU3ZGVlMTgxMzQyNjZmYTRhZjkyNmQxZjFlNWNhMjA4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIERyZXdyeSA8d2FkQGNocm9taXVtLm9yZz4KRGF0ZTog
VHVlLCAyMiBNYXkgMjAxMiAxNDo1NDoxNiAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGFyY2gveDg2
LGFzbS1nZW5lcmljOiBhZGQgc3lzY2FsbF9yZWdzLmgKCmFzbS9zeXNjYWxsLmggcHJvdmlkZXMg
YSByZWxpYWJsZSBsYXllciBvZiBhYnN0cmFjdGlvbiBmb3IgYWNjZXNzaW5nCnN5c3RlbSBjYWxs
LXJlbGF0ZWQgdmFsdWVzIGFjcm9zcyBhcmNoZXMuICBJdCBkb2Vzbid0IGNvbWUgd2l0aG91dApj
b3N0cywgYW5kIHVzaW5nIGFzbS9zeXNjYWxsLmggdmFsdWVzIGluIHBsYWNlIG9mIGRpcmVjdCBz
dHJ1Y3QgcHRfcmVncwphY2Nlc3MgYWRkcyBub24tdHJpdmlhbCBvdmVyaGVhZC4KCldoaWxlIGFz
bS9zeXNjYWxsLmggaGFzIGl0cyBwbGFjZSBlbmNvZGluZyB0cmlja3kgbG9naWMsIGxpa2UKQ09O
RklHX0NPTVBBVCBiZWhhdmlvciwgdGhlcmUgYXJlIG1hbnkgcGxhY2VzIHdoZXJlIGFyY2gtc3Bl
Y2lmaWMgY29kZQpjb3VsZCBiZSBtb3ZlZCBpbnRvIGEgc2hhcmVkIGxvY2F0aW9uIGlmIHRoZXJl
IHdlcmUgYXJjaC1hZ25vc3RpYwphY2Nlc3NvcnMgZm9yIHRoZSBzeXN0ZW0gY2FsbCByZWdpc3Rl
ciBwcm9wZXJ0aWVzLgoKYXNtL3N5c2NhbGxfcmVncy5oIHByb3ZpZGVzIGlubGluZSBmdW5jdGlv
bnMgd2hpY2ggcHJvdmlkZSBkaXJlY3QKYWNjZXNzIHRvIHRoZSBwdF9yZWdzIG1lbWJlcnMgZm9y
IHRoZSBjYXNlcyB3aGVyZSBhc20vc3lzY2FsbC5oCmRvZXNuJ3QgbWFrZSBzZW5zZSBvciBpcyB0
b28gY29zdGx5LgoKQXMgYW4gZXhhbXBsZSBhcmNoL3g4Ni9rZXJuZWwvcHRyYWNlLmMgaGFzIGJl
ZW4gY29udmVydGVkIHRvIHVzZSB0aGUKbWFjcm9zLiAgVGhlIHJlc3VsdGluZyBwdHJhY2UubyBm
aWxlIGlzIHRoZSBleGFjdCBzYW1lIHNpemUgYW5kIGNvbnRhaW5zCnRoZSBleGFjdCBzYW1lIG91
dHB1dCBhcyB0aGUgcHJlLXBhdGNoIHZlcnNpb24uCgpTdWdnZXN0ZWQtYnk6IEFsIFZpcm8gPHZp
cm9AemVuaXYubGludXgub3JnLnVrPgpTaWduZWQtb2ZmLWJ5OiBXaWxsIERyZXdyeSA8d2FkQGNo
cm9taXVtLm9yZz4KLS0tCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9zeXNjYWxsX3JlZ3MuaCB8ICAg
OTEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGFyY2gveDg2L2tlcm5lbC9w
dHJhY2UuYyAgICAgICAgICAgIHwgICAyMyArKysrKy0tLS0KIGluY2x1ZGUvYXNtLWdlbmVyaWMv
c3lzY2FsbF9yZWdzLmggIHwgICA3NiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogMyBm
aWxlcyBjaGFuZ2VkLCAxODEgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKIGNyZWF0ZSBt
b2RlIDEwMDY0NCBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9zeXNjYWxsX3JlZ3MuaAogY3JlYXRlIG1v
ZGUgMTAwNjQ0IGluY2x1ZGUvYXNtLWdlbmVyaWMvc3lzY2FsbF9yZWdzLmgKCmRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zeXNjYWxsX3JlZ3MuaCBiL2FyY2gveDg2L2luY2x1ZGUv
YXNtL3N5c2NhbGxfcmVncy5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLjY4
YWFjZjQKLS0tIC9kZXYvbnVsbAorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zeXNjYWxsX3Jl
Z3MuaApAQCAtMCwwICsxLDkxIEBACisvKgorICogRWZmaWNpZW50LCB1bmlmb3JtIGFjY2VzcyB0
byBzeXN0ZW0gY2FsbC1yZWxhdGVkIHJlZ2lzdGVycworICoKKyAqIENvcHlyaWdodCAoQykgMjAx
MiBUaGUgQ2hyb21pdW0gT1MgQXV0aG9ycyA8Y2hyb21pdW0tb3MtZGV2QGNocm9taXVtLm9yZz4K
KyAqCisgKiBUaGlzIGNvcHlyaWdodGVkIG1hdGVyaWFsIGlzIG1hZGUgYXZhaWxhYmxlIHRvIGFu
eW9uZSB3aXNoaW5nIHRvIHVzZSwKKyAqIG1vZGlmeSwgY29weSwgb3IgcmVkaXN0cmlidXRlIGl0
IHN1YmplY3QgdG8gdGhlIHRlcm1zIGFuZCBjb25kaXRpb25zCisgKiBvZiB0aGUgR05VIEdlbmVy
YWwgUHVibGljIExpY2Vuc2Ugdi4yLgorICoKKyAqIFNlZSBhc20tZ2VuZXJpYy9zeXNjYWxsX3Jl
Z3MuaCBmb3IgZGVzY3JpcHRpb25zIG9mIHdoYXQgd2UgbXVzdCBkbyBoZXJlLgorICovCisKKyNp
Zm5kZWYgX0FTTV9YODZfU1lTQ0FMTF9SRUdTX0gKKyNkZWZpbmUgX0FTTV9YODZfU1lTQ0FMTF9S
RUdTX0gKKworI2luY2x1ZGUgPGFzbS91bmlzdGQuaD4KKworc3RhdGljIGlubGluZSB1bnNpZ25l
ZCBsb25nICpyZWdzX3N5c2NhbGxfbnIoc3RydWN0IHB0X3JlZ3MgKnJlZ3MpCit7CisJcmV0dXJu
ICZyZWdzLT5vcmlnX2F4OworfQorCitzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgKnJlZ3Nf
c3lzY2FsbF9yZXR1cm4oc3RydWN0IHB0X3JlZ3MgKnJlZ3MpCit7CisJLyogTm90ZSEgVGhpcyBk
b2VzIG5vdCBoYW5kbGUgY29tcGF0IG1vZGUgc2lnbiBleHRlbnNpb24sIGV0YyAqLworCXJldHVy
biAmcmVncy0+YXg7Cit9CisKK3N0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyAqcmVnc19zeXNj
YWxsMzJfYXJnMShzdHJ1Y3QgcHRfcmVncyAqcmVncykKK3sKKwkJcmV0dXJuICZyZWdzLT5ieDsK
K30KKworc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nICpyZWdzX3N5c2NhbGwzMl9hcmcyKHN0
cnVjdCBwdF9yZWdzICpyZWdzKQoreworCQlyZXR1cm4gJnJlZ3MtPmN4OworfQorCitzdGF0aWMg
aW5saW5lIHVuc2lnbmVkIGxvbmcgKnJlZ3Nfc3lzY2FsbDMyX2FyZzMoc3RydWN0IHB0X3JlZ3Mg
KnJlZ3MpCit7CisJCXJldHVybiAmcmVncy0+ZHg7Cit9CisKK3N0YXRpYyBpbmxpbmUgdW5zaWdu
ZWQgbG9uZyAqcmVnc19zeXNjYWxsMzJfYXJnNChzdHJ1Y3QgcHRfcmVncyAqcmVncykKK3sKKwkJ
cmV0dXJuICZyZWdzLT5zaTsKK30KKworc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nICpyZWdz
X3N5c2NhbGwzMl9hcmc1KHN0cnVjdCBwdF9yZWdzICpyZWdzKQoreworCQlyZXR1cm4gJnJlZ3Mt
PmRpOworfQorCitzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgKnJlZ3Nfc3lzY2FsbDMyX2Fy
ZzYoc3RydWN0IHB0X3JlZ3MgKnJlZ3MpCit7CisJCXJldHVybiAmcmVncy0+YnA7Cit9CisKKyNp
ZmRlZiBDT05GSUdfWDg2XzY0CitzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgKnJlZ3Nfc3lz
Y2FsbDY0X2FyZzEoc3RydWN0IHB0X3JlZ3MgKnJlZ3MpCit7CisJCXJldHVybiAmcmVncy0+ZGk7
Cit9CisKK3N0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyAqcmVnc19zeXNjYWxsNjRfYXJnMihz
dHJ1Y3QgcHRfcmVncyAqcmVncykKK3sKKwkJcmV0dXJuICZyZWdzLT5zaTsKK30KKworc3RhdGlj
IGlubGluZSB1bnNpZ25lZCBsb25nICpyZWdzX3N5c2NhbGw2NF9hcmczKHN0cnVjdCBwdF9yZWdz
ICpyZWdzKQoreworCQlyZXR1cm4gJnJlZ3MtPmR4OworfQorCitzdGF0aWMgaW5saW5lIHVuc2ln
bmVkIGxvbmcgKnJlZ3Nfc3lzY2FsbDY0X2FyZzQoc3RydWN0IHB0X3JlZ3MgKnJlZ3MpCit7CisJ
CXJldHVybiAmcmVncy0+cjEwOworfQorCitzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgKnJl
Z3Nfc3lzY2FsbDY0X2FyZzUoc3RydWN0IHB0X3JlZ3MgKnJlZ3MpCit7CisJCXJldHVybiAmcmVn
cy0+cjg7Cit9CisKK3N0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyAqcmVnc19zeXNjYWxsNjRf
YXJnNihzdHJ1Y3QgcHRfcmVncyAqcmVncykKK3sKKwkJcmV0dXJuICZyZWdzLT5yOTsKK30KKyNl
bmRpZgkvKiBDT05GSUdfWDg2XzY0ICovCisKKyNlbmRpZgkvKiBfQVNNX1g4Nl9TWVNDQUxMX1JF
R1NfSCAqLwpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL3B0cmFjZS5jIGIvYXJjaC94ODYv
a2VybmVsL3B0cmFjZS5jCmluZGV4IDEzNDc0ZDAuLmEwMmFjMmEgMTAwNjQ0Ci0tLSBhL2FyY2gv
eDg2L2tlcm5lbC9wdHJhY2UuYworKysgYi9hcmNoL3g4Ni9rZXJuZWwvcHRyYWNlLmMKQEAgLTM0
LDYgKzM0LDcgQEAKICNpbmNsdWRlIDxhc20vcHJvdG8uaD4KICNpbmNsdWRlIDxhc20vaHdfYnJl
YWtwb2ludC5oPgogI2luY2x1ZGUgPGFzbS90cmFwcy5oPgorI2luY2x1ZGUgPGFzbS9zeXNjYWxs
X3JlZ3MuaD4KIAogI2luY2x1ZGUgInRscy5oIgogCkBAIC0xNDg3LDI5ICsxNDg4LDMzIEBAIGxv
bmcgc3lzY2FsbF90cmFjZV9lbnRlcihzdHJ1Y3QgcHRfcmVncyAqcmVncykKIAkJcmV0ID0gLTFM
OwogCiAJLyogZG8gdGhlIHNlY3VyZSBjb21wdXRpbmcgYWZ0ZXIgdXNlcnNwYWNlIGNhbid0IGNo
YW5nZSB0aGUgc3lzY2FsbC4gKi8KLQlpZiAoIXJldCAmJiBzZWN1cmVfY29tcHV0aW5nKHJlZ3Mt
Pm9yaWdfYXgpKSB7CisJaWYgKCFyZXQgJiYgc2VjdXJlX2NvbXB1dGluZygqcmVnc19zeXNjYWxs
X25yKHJlZ3MpKSkgewogCQlyZXQgPSAtMUw7CiAJCWdvdG8gb3V0OwogCX0KIAogCWlmICh1bmxp
a2VseSh0ZXN0X3RocmVhZF9mbGFnKFRJRl9TWVNDQUxMX1RSQUNFUE9JTlQpKSkKLQkJdHJhY2Vf
c3lzX2VudGVyKHJlZ3MsIHJlZ3MtPm9yaWdfYXgpOworCQl0cmFjZV9zeXNfZW50ZXIocmVncywg
KnJlZ3Nfc3lzY2FsbF9ucihyZWdzKSk7CiAKIAlpZiAoSVNfSUEzMikKIAkJYXVkaXRfc3lzY2Fs
bF9lbnRyeShBVURJVF9BUkNIX0kzODYsCi0JCQkJICAgIHJlZ3MtPm9yaWdfYXgsCi0JCQkJICAg
IHJlZ3MtPmJ4LCByZWdzLT5jeCwKLQkJCQkgICAgcmVncy0+ZHgsIHJlZ3MtPnNpKTsKKwkJCQkg
ICAgKnJlZ3Nfc3lzY2FsbF9ucihyZWdzKSwKKwkJCQkgICAgKnJlZ3Nfc3lzY2FsbDMyX2FyZzEo
cmVncyksCisJCQkJICAgICpyZWdzX3N5c2NhbGwzMl9hcmcyKHJlZ3MpLAorCQkJCSAgICAqcmVn
c19zeXNjYWxsMzJfYXJnMyhyZWdzKSwKKwkJCQkgICAgKnJlZ3Nfc3lzY2FsbDMyX2FyZzQocmVn
cykpOwogI2lmZGVmIENPTkZJR19YODZfNjQKIAllbHNlCiAJCWF1ZGl0X3N5c2NhbGxfZW50cnko
QVVESVRfQVJDSF9YODZfNjQsCi0JCQkJICAgIHJlZ3MtPm9yaWdfYXgsCi0JCQkJICAgIHJlZ3Mt
PmRpLCByZWdzLT5zaSwKLQkJCQkgICAgcmVncy0+ZHgsIHJlZ3MtPnIxMCk7CisJCQkJICAgICpy
ZWdzX3N5c2NhbGxfbnIocmVncyksCisJCQkJICAgICpyZWdzX3N5c2NhbGw2NF9hcmcxKHJlZ3Mp
LAorCQkJCSAgICAqcmVnc19zeXNjYWxsNjRfYXJnMihyZWdzKSwKKwkJCQkgICAgKnJlZ3Nfc3lz
Y2FsbDY0X2FyZzMocmVncyksCisJCQkJICAgICpyZWdzX3N5c2NhbGw2NF9hcmc0KHJlZ3MpKTsK
ICNlbmRpZgogCiBvdXQ6Ci0JcmV0dXJuIHJldCA/OiByZWdzLT5vcmlnX2F4OworCXJldHVybiBy
ZXQgPzogc3lzY2FsbF9nZXRfbnIoY3VycmVudCwgcmVncyk7CiB9CiAKIHZvaWQgc3lzY2FsbF90
cmFjZV9sZWF2ZShzdHJ1Y3QgcHRfcmVncyAqcmVncykKZGlmZiAtLWdpdCBhL2luY2x1ZGUvYXNt
LWdlbmVyaWMvc3lzY2FsbF9yZWdzLmggYi9pbmNsdWRlL2FzbS1nZW5lcmljL3N5c2NhbGxfcmVn
cy5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLjdiM2ZiNWIKLS0tIC9kZXYv
bnVsbAorKysgYi9pbmNsdWRlL2FzbS1nZW5lcmljL3N5c2NhbGxfcmVncy5oCkBAIC0wLDAgKzEs
NzYgQEAKKy8qCisgKiBFZmZpY2llbnQsIHVuaWZvcm0gYWNjZXNzIHRvIHN5c3RlbSBjYWxsLXJl
bGF0ZWQgcmVnaXN0ZXJzCisgKgorICogQ29weXJpZ2h0IChDKSAyMDEyIFRoZSBDaHJvbWl1bSBP
UyBBdXRob3JzIDxjaHJvbWl1bS1vcy1kZXZAY2hyb21pdW0ub3JnPgorICoKKyAqIFRoaXMgY29w
eXJpZ2h0ZWQgbWF0ZXJpYWwgaXMgbWFkZSBhdmFpbGFibGUgdG8gYW55b25lIHdpc2hpbmcgdG8g
dXNlLAorICogbW9kaWZ5LCBjb3B5LCBvciByZWRpc3RyaWJ1dGUgaXQgc3ViamVjdCB0byB0aGUg
dGVybXMgYW5kIGNvbmRpdGlvbnMKKyAqIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5z
ZSB2LjIuCisgKgorICogVGhpcyBmaWxlIGlzIGEgc3R1YiBwcm92aWRpbmcgZG9jdW1lbnRhdGlv
biBmb3Igd2hhdCBmdW5jdGlvbnMKKyAqIGFzbS1BUkNIL3N5c2NhbGxfcmVncy5oIGZpbGVzIG5l
ZWQgdG8gZGVmaW5lLiBBbGwgYXJjaCBkZWZpbml0aW9ucworICogc2hvdWxkIGJlIHNpbXBsZSBp
bmxpbmVzLgorICoKKyAqIEFsbCBmdW5jdGlvbnMgYXJlIG1lYW50IHRvIGJlIGNyb3NzLWFyY2gg
YWNjZXNzb3JzIGludG8gcHRfcmVncy4KKyAqIFRoaXMgbWVhbnMgdGhhdCBubyBsb2NrcyBhcmUg
ZXhwZWN0ZWQgYW5kIGEgcG9wdWxhdGVkIHB0X3JlZ3MgaXMKKyAqIGV4cGVjdGVkLiAgSXQgYWxz
byBtZWFucyB0aGF0IGFueSBwZXItYXJjaCBleHBlY3RhdGlvbnMsIGxpa2UKKyAqIHJ1bnRpbWUg
Q09ORklHX0NPTVBBVCBiZWhhdmlvciwgbXVzdCBiZSBoYW5kbGVkIGJ5IHRoZSBjYWxsZXIuCisg
KgorICogU2VlIGFzbS9zeXNjYWxsLmggZm9yIGltcGxlbWVudGF0aW9ucyB0aGF0IGhhbmRsZSBo
aWdoZXIgbGV2ZWwKKyAqIHJ1bnRpbWUgbG9naWMuCisgKi8KKworI2lmbmRlZiBfQVNNX1g4Nl9T
WVNDQUxMX1JFR1NfSAorI2RlZmluZSBfQVNNX1g4Nl9TWVNDQUxMX1JFR1NfSAorCitzdHJ1Y3Qg
cHRfcmVnczsKKworLyoqCisgKiByZWdzX3N5c2NhbGxfbnIgLSByZXR1cm5zIGEgcG9pbnRlciB0
byB0aGUgc3lzdGVtIGNhbGwgbnVtYmVyIGVudHJ5CisgKiBAcmVnczoJdGFza19wdF9yZWdzKCkg
Zm9yIHRoZSB0YXJnZXRlZCB0YXNrCisgKgorICogSXQncyBvbmx5IHZhbGlkIHRvIGNhbGwgdGhp
cyB3aGVuIEByZWdzIGlzIGtub3duIHRvIGJlIHBvcHVsYXRlZCBhbmQKKyAqIHRoZSBjYWxsZXIg
aXMgdGhlIG9ubHkgcmVhZGVyL3dyaXRlci4KKyAqLworc3RhdGljIGlubGluZSB1bnNpZ25lZCBs
b25nICpyZWdzX3N5c2NhbGxfbnIoc3RydWN0IHB0X3JlZ3MgKnJlZ3MpOworCisvKioKKyAqIHJl
Z3Nfc3lzY2FsbF9yZXR1cm4gLSByZXR1cm5zIGEgcG9pbnRlciB0byB0aGUgc3lzdGVtIGNhbGwg
cmV0dXJuIHZhbHVlIGVudHJ5CisgKiBAcmVnczoJdGFza19wdF9yZWdzKCkgZm9yIHRoZSB0YXJn
ZXRlZCB0YXNrCisgKgorICogSXQncyBvbmx5IHZhbGlkIHRvIGNhbGwgdGhpcyB3aGVuIEByZWdz
IGlzIGtub3duIHRvIGJlIHBvcHVsYXRlZCBhbmQKKyAqIHRoZSBjYWxsZXIgaXMgdGhlIG9ubHkg
cmVhZGVyL3dyaXRlci4KKyAqLworc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nICpyZWdzX3N5
c2NhbGxfcmV0dXJuKHN0cnVjdCBwdF9yZWdzICpyZWdzKTsKKworLyoqCisgKiByZWdzX3N5c2Nh
bGwzMl9hcmcxLi4uNiAtIHJldHVybnMgYSBwb2ludGVyIHRvIHRoZSBzeXN0ZW0gY2FsbCBhcmcg
ZW50cnkKKyAqIEByZWdzOgl0YXNrX3B0X3JlZ3MoKSBmb3IgdGhlIHRhcmdldGVkIHRhc2sKKyAq
CisgKiBJdCdzIG9ubHkgdmFsaWQgdG8gY2FsbCB0aGlzIHdoZW4gQHJlZ3MgaXMga25vd24gdG8g
YmUgcG9wdWxhdGVkIGFuZAorICogdGhlIGNhbGxlciBpcyB0aGUgb25seSByZWFkZXIvd3JpdGVy
LiAgVGhlIGJlaGF2aW9yIGlzIHVuZGVmaW5lZCBpZgorICogdGhlc2UgZnVuY3Rpb25zIGFyZSBj
YWxsZWQgb24gbm9uLTMyLWJpdCBzeXN0ZW0gY2FsbCBhcmd1bWVudCByZWdpc3RlcnMuCisgKi8K
K3N0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyAqcmVnc19zeXNjYWxsMzJfYXJnMShzdHJ1Y3Qg
cHRfcmVncyAqcmVncyk7CitzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgKnJlZ3Nfc3lzY2Fs
bDMyX2FyZzIoc3RydWN0IHB0X3JlZ3MgKnJlZ3MpOworc3RhdGljIGlubGluZSB1bnNpZ25lZCBs
b25nICpyZWdzX3N5c2NhbGwzMl9hcmczKHN0cnVjdCBwdF9yZWdzICpyZWdzKTsKK3N0YXRpYyBp
bmxpbmUgdW5zaWduZWQgbG9uZyAqcmVnc19zeXNjYWxsMzJfYXJnNChzdHJ1Y3QgcHRfcmVncyAq
cmVncyk7CitzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgKnJlZ3Nfc3lzY2FsbDMyX2FyZzUo
c3RydWN0IHB0X3JlZ3MgKnJlZ3MpOworc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nICpyZWdz
X3N5c2NhbGwzMl9hcmc2KHN0cnVjdCBwdF9yZWdzICpyZWdzKTsKKworLyoqCisgKiByZWdzX3N5
c2NhbGw2NF9hcmcxLi4uNiAtIHJldHVybnMgYSBwb2ludGVyIHRvIHRoZSBzeXN0ZW0gY2FsbCBh
cmcgZW50cnkKKyAqIEByZWdzOgl0YXNrX3B0X3JlZ3MoKSBmb3IgdGhlIHRhcmdldGVkIHRhc2sK
KyAqCisgKiBJdCdzIG9ubHkgdmFsaWQgdG8gY2FsbCB0aGlzIHdoZW4gQHJlZ3MgaXMga25vd24g
dG8gYmUgcG9wdWxhdGVkIGFuZAorICogdGhlIGNhbGxlciBpcyB0aGUgb25seSByZWFkZXIvd3Jp
dGVyLiAgVGhlIGJlaGF2aW9yIGlzIHVuZGVmaW5lZCBpZgorICogdGhlc2UgZnVuY3Rpb25zIGFy
ZSBjYWxsZWQgb24gbm9uLTMyLWJpdCBzeXN0ZW0gY2FsbCBhcmd1bWVudCByZWdpc3RlcnMuCisg
Ki8KK3N0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyAqcmVnc19zeXNjYWxsMzJfYXJnMShzdHJ1
Y3QgcHRfcmVncyAqcmVncyk7CitzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgKnJlZ3Nfc3lz
Y2FsbDMyX2FyZzIoc3RydWN0IHB0X3JlZ3MgKnJlZ3MpOworc3RhdGljIGlubGluZSB1bnNpZ25l
ZCBsb25nICpyZWdzX3N5c2NhbGwzMl9hcmczKHN0cnVjdCBwdF9yZWdzICpyZWdzKTsKK3N0YXRp
YyBpbmxpbmUgdW5zaWduZWQgbG9uZyAqcmVnc19zeXNjYWxsMzJfYXJnNChzdHJ1Y3QgcHRfcmVn
cyAqcmVncyk7CitzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgKnJlZ3Nfc3lzY2FsbDMyX2Fy
ZzUoc3RydWN0IHB0X3JlZ3MgKnJlZ3MpOworc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nICpy
ZWdzX3N5c2NhbGwzMl9hcmc2KHN0cnVjdCBwdF9yZWdzICpyZWdzKTsKKworI2VuZGlmCS8qIF9B
U01fWDg2X1NZU0NBTExfUkVHU19IICovCi0tIAoxLjcuOS41Cgo=
--f46d043bd6fadf412004c0a5d4f2--
