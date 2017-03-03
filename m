Content-Type: multipart/alternative;
	boundary=Apple-Mail-FEFC33F2-B80A-4F16-A97E-8686D76B7034
Mime-Version: 1.0 (1.0)
From: Hoeun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <20170301112436.GC28874@leverpostej>
Date: Fri, 3 Mar 2017 09:59:15 +0900
Content-Transfer-Encoding: 7bit
Message-Id: <A521BCC5-BFAA-47A8-A795-433EBA297F9A@gmail.com>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org> <1488228186-110679-5-git-send-email-keescook@chromium.org> <CALCETrUruKRCnHAEVg6pXe+43WQx7K6LCOHg5zVEjLfzw8nQUA@mail.gmail.com> <CAGXu5jK2ppnFGA3SG76BPkmGGeZcK3-5k9XaHihkmWkwPvomgw@mail.gmail.com> <CALCETrV=HmBxUK9rp1JiJZuX78XWmmt8-mXFohEAUXyS4z6+oQ@mail.gmail.com> <CAGXu5jLWL8cUV5nTqCB5ganimuFfvNwaAW9STBvwU-UM9pgbEg@mail.gmail.com> <20170301112436.GC28874@leverpostej>
Subject: [kernel-hardening] Re: [RFC][PATCH 4/8] x86: Implement __arch_rare_write_map/unmap()
To: Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--Apple-Mail-FEFC33F2-B80A-4F16-A97E-8686D76B7034
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable


>> On Mar 1, 2017, at 8:24 PM, Mark Rutland <mark.rutland@arm.com> wrote:
>>=20
>>> On Tue, Feb 28, 2017 at 03:52:26PM -0800, Kees Cook wrote:
>>> On Tue, Feb 28, 2017 at 2:54 PM, Andy Lutomirski <luto@amacapital.net> w=
rote:
>>> On Tue, Feb 28, 2017 at 1:35 PM, Kees Cook <keescook@chromium.org> wrote=
:
>>>>> Can't we at least make this:
>>>>>=20
>>>>> struct rare_write_mapping {
>>>>> void *addr;
>>>>> struct arch_rare_write_state arch_state;
>>>>> };
>>>>>=20
>>>>> static inline struct rare_write_mapping __arch_rare_write_map(void
>>>>> *addr, size_t len);
>>>>> static inline void __arch_rare_write_unmap(struct rare_write_mapping m=
apping);
>>>>=20
>>>> How do you envision this working with the more complex things I
>>>> included in the latter patches of the series, namely doing linked list
>>>> updates across multiple structure instances, etc?
>>>>=20
>>>> ie, poor list manipulation pseudo-code:
>>>>=20
>>>> turn off read-only;
>>>> struct_one->next =3D struct_tree->node;
>>>> struct_three->prev =3D struct_one->node;
>>>> struct_two->prev =3D struct_two->next =3D NULL;
>>>> turn on read-only;
>>>>=20
>>>> That's three separate memory areas involved...
>>>=20
>>> Fair enough.  That being said, how is this supposed to work on
>>> architectures that don't have a global "disable write protection" bit?
>>> Surely these architectures exist.
>>=20
>> I don't know. :) That's part of the reason for putting up this series:
>> looking to see what's possible on other architectures. It's not clear
>> to me what arm64 can do, for example.
>=20
> There is no global override of this sort on arm64. Just having map/unap,
> open/close, shed/unshed, etc, won't work.
>=20
> The options I can think of for arm64 are:
>=20
> * Have a separate RW alias of just the write_rarely data, that we
> temporarily map-in on a given CPU (using TTBR0) to perform the write.
> The RW alias is at a different VA to the usual RO alias, so we have to
> convert each pointer to its RW alias to perform the write. That's why
> we need __rare_write_ptr() to hide this, and can't have uninstrumented
> writes.
>=20
> Since this would *only* map the write_rarely data, it's simple to set
> up, and we don't need to modify the tables at runtime.
>=20
> I also think we can implement this generically using switch_mm() and
> {get,put}_user(), or specialised variants thereof.
>=20
> Assuming we can figure out how to handle those complex cases, this is
> my preferred solution. :)

I implemented RFC version of the option #1 .
It would be appreciated if you could review the code [1].

[1] http://www.openwall.com/lists/kernel-hardening/2017/03/02/5

>=20
> * Have a copy of the entire swapper page tables, which differs only in
> the write_rarely data being RW. We then switch TTBR1 over to this for
> the duration of the rare_write_map() .. write_write_unmap() sequence.
>=20
> While this sounds conceptually simple, it's far more complex in
> practice. Keeping the not-quite-clone of the swapper in-sync is going
> to be very painful and ripe for error.
>=20
> Additionally, the TTBR1 switch will be very expensive, far more so
> than the TTBR0 switch due to TLB maintenance and other work (including
> switching TTBR0 twice per TTBR1 switch, itself requiring synchronised
> TLB maintenance and other work).
>=20
> I am not fond of this approach.
>=20
> * Give up on this being per-cpu. Either change the permissions in place,
> or fixmap an RW alias as required. In either case, all CPUs will have
> RW access.
>=20
> Thanks,
> Mark.

--Apple-Mail-FEFC33F2-B80A-4F16-A97E-8686D76B7034
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; charset=3D=
utf-8"></head><body dir=3D"auto"><div><span></span></div><div><span></span><=
br><div></div><blockquote type=3D"cite"><span>On Mar 1, 2017, at 8:24 PM, Ma=
rk Rutland &lt;<a href=3D"mailto:mark.rutland@arm.com">mark.rutland@arm.com<=
/a>&gt; wrote:</span><br></blockquote><blockquote type=3D"cite"><span></span=
><br></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>=
On Tue, Feb 28, 2017 at 03:52:26PM -0800, Kees Cook wrote:</span><br></block=
quote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><bloc=
kquote type=3D"cite"><span>On Tue, Feb 28, 2017 at 2:54 PM, Andy Lutomirski &=
lt;<a href=3D"mailto:luto@amacapital.net">luto@amacapital.net</a>&gt; wrote:=
</span><br></blockquote></blockquote></blockquote><blockquote type=3D"cite">=
<blockquote type=3D"cite"><blockquote type=3D"cite"><span>On Tue, Feb 28, 20=
17 at 1:35 PM, Kees Cook &lt;<a href=3D"mailto:keescook@chromium.org">keesco=
ok@chromium.org</a>&gt; wrote:</span><br></blockquote></blockquote></blockqu=
ote><blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"=
cite"><blockquote type=3D"cite"><blockquote type=3D"cite"><span>Can't we at l=
east make this:</span><br></blockquote></blockquote></blockquote></blockquot=
e></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><blockquo=
te type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cite"><span><=
/span><br></blockquote></blockquote></blockquote></blockquote></blockquote><=
blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cite"=
><blockquote type=3D"cite"><blockquote type=3D"cite"><span>struct rare_write=
_mapping {</span><br></blockquote></blockquote></blockquote></blockquote></b=
lockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote ty=
pe=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cite"><span> void *=
addr;</span><br></blockquote></blockquote></blockquote></blockquote></blockq=
uote><blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D=
"cite"><blockquote type=3D"cite"><blockquote type=3D"cite"><span> struct arc=
h_rare_write_state arch_state;</span><br></blockquote></blockquote></blockqu=
ote></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"=
cite"><blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D=
"cite"><span>};</span><br></blockquote></blockquote></blockquote></blockquot=
e></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><blockquo=
te type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cite"><span><=
/span><br></blockquote></blockquote></blockquote></blockquote></blockquote><=
blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cite"=
><blockquote type=3D"cite"><blockquote type=3D"cite"><span>static inline str=
uct rare_write_mapping __arch_rare_write_map(void</span><br></blockquote></b=
lockquote></blockquote></blockquote></blockquote><blockquote type=3D"cite"><=
blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cite"=
><blockquote type=3D"cite"><span>*addr, size_t len);</span><br></blockquote>=
</blockquote></blockquote></blockquote></blockquote><blockquote type=3D"cite=
"><blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"ci=
te"><blockquote type=3D"cite"><span>static inline void __arch_rare_write_unm=
ap(struct rare_write_mapping mapping);</span><br></blockquote></blockquote><=
/blockquote></blockquote></blockquote><blockquote type=3D"cite"><blockquote t=
ype=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cite"><span></spa=
n><br></blockquote></blockquote></blockquote></blockquote><blockquote type=3D=
"cite"><blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D=
"cite"><span>How do you envision this working with the more complex things I=
</span><br></blockquote></blockquote></blockquote></blockquote><blockquote t=
ype=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote=
 type=3D"cite"><span>included in the latter patches of the series, namely do=
ing linked list</span><br></blockquote></blockquote></blockquote></blockquot=
e><blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"ci=
te"><blockquote type=3D"cite"><span>updates across multiple structure instan=
ces, etc?</span><br></blockquote></blockquote></blockquote></blockquote><blo=
ckquote type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cite"><b=
lockquote type=3D"cite"><span></span><br></blockquote></blockquote></blockqu=
ote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><blockq=
uote type=3D"cite"><blockquote type=3D"cite"><span>ie, poor list manipulatio=
n pseudo-code:</span><br></blockquote></blockquote></blockquote></blockquote=
><blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cit=
e"><blockquote type=3D"cite"><span></span><br></blockquote></blockquote></bl=
ockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><b=
lockquote type=3D"cite"><blockquote type=3D"cite"><span>turn off read-only;<=
/span><br></blockquote></blockquote></blockquote></blockquote><blockquote ty=
pe=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote t=
ype=3D"cite"><span>struct_one-&gt;next =3D struct_tree-&gt;node;</span><br><=
/blockquote></blockquote></blockquote></blockquote><blockquote type=3D"cite"=
><blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cit=
e"><span>struct_three-&gt;prev =3D struct_one-&gt;node;</span><br></blockquo=
te></blockquote></blockquote></blockquote><blockquote type=3D"cite"><blockqu=
ote type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cite"><span>=
struct_two-&gt;prev =3D struct_two-&gt;next =3D NULL;</span><br></blockquote=
></blockquote></blockquote></blockquote><blockquote type=3D"cite"><blockquot=
e type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cite"><span>tu=
rn on read-only;</span><br></blockquote></blockquote></blockquote></blockquo=
te><blockquote type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"c=
ite"><blockquote type=3D"cite"><span></span><br></blockquote></blockquote></=
blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite">=
<blockquote type=3D"cite"><blockquote type=3D"cite"><span>That's three separ=
ate memory areas involved...</span><br></blockquote></blockquote></blockquot=
e></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><blockquo=
te type=3D"cite"><span></span><br></blockquote></blockquote></blockquote><bl=
ockquote type=3D"cite"><blockquote type=3D"cite"><blockquote type=3D"cite"><=
span>Fair enough. &nbsp;That being said, how is this supposed to work on</sp=
an><br></blockquote></blockquote></blockquote><blockquote type=3D"cite"><blo=
ckquote type=3D"cite"><blockquote type=3D"cite"><span>architectures that don=
't have a global "disable write protection" bit?</span><br></blockquote></bl=
ockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><b=
lockquote type=3D"cite"><span>Surely these architectures exist.</span><br></=
blockquote></blockquote></blockquote><blockquote type=3D"cite"><blockquote t=
ype=3D"cite"><span></span><br></blockquote></blockquote><blockquote type=3D"=
cite"><blockquote type=3D"cite"><span>I don't know. :) That's part of the re=
ason for putting up this series:</span><br></blockquote></blockquote><blockq=
uote type=3D"cite"><blockquote type=3D"cite"><span>looking to see what's pos=
sible on other architectures. It's not clear</span><br></blockquote></blockq=
uote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>to me what ar=
m64 can do, for example.</span><br></blockquote></blockquote><blockquote typ=
e=3D"cite"><span></span><br></blockquote><blockquote type=3D"cite"><span>The=
re is no global override of this sort on arm64. Just having map/unap,</span>=
<br></blockquote><blockquote type=3D"cite"><span>open/close, shed/unshed, et=
c, won't work.</span><br></blockquote><blockquote type=3D"cite"><span></span=
><br></blockquote><blockquote type=3D"cite"><span>The options I can think of=
 for arm64 are:</span><br></blockquote><blockquote type=3D"cite"><span></spa=
n><br></blockquote><blockquote type=3D"cite"><span>* Have a separate RW alia=
s of just the write_rarely data, that we</span><br></blockquote><blockquote t=
ype=3D"cite"><span> temporarily map-in on a given CPU (using TTBR0) to perfo=
rm the write.</span><br></blockquote><blockquote type=3D"cite"><span> The RW=
 alias is at a different VA to the usual RO alias, so we have to</span><br><=
/blockquote><blockquote type=3D"cite"><span> convert each pointer to its RW a=
lias to perform the write. That's why</span><br></blockquote><blockquote typ=
e=3D"cite"><span> we need __rare_write_ptr() to hide this, and can't have un=
instrumented</span><br></blockquote><blockquote type=3D"cite"><span> writes.=
</span><br></blockquote><blockquote type=3D"cite"><span></span><br></blockqu=
ote><blockquote type=3D"cite"><span> Since this would *only* map the write_r=
arely data, it's simple to set</span><br></blockquote><blockquote type=3D"ci=
te"><span> up, and we don't need to modify the tables at runtime.</span><br>=
</blockquote><blockquote type=3D"cite"><span></span><br></blockquote><blockq=
uote type=3D"cite"><span> I also think we can implement this generically usi=
ng switch_mm() and</span><br></blockquote><blockquote type=3D"cite"><span> {=
get,put}_user(), or specialised variants thereof.</span><br></blockquote><bl=
ockquote type=3D"cite"><span></span><br></blockquote><blockquote type=3D"cit=
e"><span> Assuming we can figure out how to handle those complex cases, this=
 is</span><br></blockquote><blockquote type=3D"cite"><span> my preferred sol=
ution. :)</span><br></blockquote><span></span><br><span>I implemented RFC ve=
rsion of the option #1 .</span><br><span>It would be appreciated if you coul=
d review the code [1].</span><br><br>[1]&nbsp;<a href=3D"http://www.openwall=
.com/lists/kernel-hardening/2017/03/02/5">http://www.openwall.com/lists/kern=
el-hardening/2017/03/02/5</a></div><div><br><blockquote type=3D"cite"><span>=
</span><br></blockquote><blockquote type=3D"cite"><span>* Have a copy of the=
 entire swapper page tables, which differs only in</span><br></blockquote><b=
lockquote type=3D"cite"><span> the write_rarely data being RW. We then switc=
h TTBR1 over to this for</span><br></blockquote><blockquote type=3D"cite"><s=
pan> the duration of the rare_write_map() .. write_write_unmap() sequence.</=
span><br></blockquote><blockquote type=3D"cite"><span></span><br></blockquot=
e><blockquote type=3D"cite"><span> While this sounds conceptually simple, it=
's far more complex in</span><br></blockquote><blockquote type=3D"cite"><spa=
n> practice. Keeping the not-quite-clone of the swapper in-sync is going</sp=
an><br></blockquote><blockquote type=3D"cite"><span> to be very painful and r=
ipe for error.</span><br></blockquote><blockquote type=3D"cite"><span></span=
><br></blockquote><blockquote type=3D"cite"><span> Additionally, the TTBR1 s=
witch will be very expensive, far more so</span><br></blockquote><blockquote=
 type=3D"cite"><span> than the TTBR0 switch due to TLB maintenance and other=
 work (including</span><br></blockquote><blockquote type=3D"cite"><span> swi=
tching TTBR0 twice per TTBR1 switch, itself requiring synchronised</span><br=
></blockquote><blockquote type=3D"cite"><span> TLB maintenance and other wor=
k).</span><br></blockquote><blockquote type=3D"cite"><span></span><br></bloc=
kquote><blockquote type=3D"cite"><span> I am not fond of this approach.</spa=
n><br></blockquote><blockquote type=3D"cite"><span></span><br></blockquote><=
blockquote type=3D"cite"><span>* Give up on this being per-cpu. Either chang=
e the permissions in place,</span><br></blockquote><blockquote type=3D"cite"=
><span> or fixmap an RW alias as required. In either case, all CPUs will hav=
e</span><br></blockquote><blockquote type=3D"cite"><span> RW access.</span><=
br></blockquote><blockquote type=3D"cite"><span></span><br></blockquote><blo=
ckquote type=3D"cite"><span>Thanks,</span><br></blockquote><blockquote type=3D=
"cite"><span>Mark.</span><br></blockquote></div></body></html>=

--Apple-Mail-FEFC33F2-B80A-4F16-A97E-8686D76B7034--
