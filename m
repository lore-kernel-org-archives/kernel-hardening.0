Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C3EFCD@IRSMSX102.ger.corp.intel.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
 <1484730707-29313-10-git-send-email-elena.reshetova@intel.com>
 <CAEXv5_gP0bp+NbVVEgMo=sgY5FxG1aKCCdhmF2_2vsXDzQwFOQ@mail.gmail.com>
 <CAGXu5j+QnAuRGKpH7tqc7LGfQ_JvTDPW8XrrCdkjizt-z0=vvw@mail.gmail.com>
 <CAEXv5_gBx2pgej_7RQD3o+OfSY2RSkDRq_vmOLtLOq66io9BQA@mail.gmail.com> <2236FBA76BA1254E88B949DDB74E612B41C3EFCD@IRSMSX102.ger.corp.intel.com>
From: David Windsor <dwindsor@gmail.com>
Date: Thu, 19 Jan 2017 10:08:25 -0500
Message-ID: <CAEXv5_i4wSg_1c_0_Dv-3Eir3Y2U=ziY8jF3yieSmRJgKMgbPQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a11440f02b7ce9d054673e74e
Subject: [kernel-hardening] Re: [RFCv2 PATCH 09/18] net: convert from atomic_t to refcount_t
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a11440f02b7ce9d054673e74e
Content-Type: text/plain; charset=UTF-8

It might be my mail client: Gmail won't display the entire patch inline.

On Thursday, January 19, 2017, Reshetova, Elena <elena.reshetova@intel.com>
wrote:
>> On Wed, Jan 18, 2017 at 8:11 PM, Kees Cook <keescook@chromium.org> wrote:
>> > On Wed, Jan 18, 2017 at 10:39 AM, David Windsor <dwindsor@gmail.com>
>> wrote:
>> >> The relevant part of the patch has been cut off, but it appears that
>> >> you've fixed some of the issues we identified earlier as corner cases
>> >> as to reference counting in net/.  In particular, inetpeer.c has its
>> >> own garbage collection system in place which frees shared objects when
>> >> their reference count became -1 (rather than 0).  The proposed
>> >> solution was to do a global +1 on this refcounting scheme, then
>> >> replace unsupported atomic_*() functions with appropriate refcount_*()
>> >> calls.
>> >>
>> >> When submitting this to netdev, it may make sense to separate out
>> >> these changes: first, do a global +1 (while still using atomic_t),
>> >> then convert to refcount_t.  I'm already working on this now, but I
>> >> didn't know if you wanted to follow this approach or not.
>> >
>> > David, if you've got the global +1 patches ready, let's start feeding
>> > those to netdev ASAP. We can convert them to refcount_t more easily
>> > after that.
>> >
>>
>> Alright, let me get them in order and I'll submit them to netdev.  I
>> just wanted to make sure that an alternate approach hadn't been
>> decided upon.
>>
>
> No, we haven't decided on that.
> We had only some +1s, but not for all of it, so if you have a global +1,
then it is even better!
> Then we can drop +1 parts.
>
> And what do you mean by " The relevant part of the patch has been cut off
" ? It is one huge
> patch but I got it in full mailed via list. Do you see it corrupted or?
>
> Best Regards,
> Elena
>

--001a11440f02b7ce9d054673e74e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

It might be my mail client: Gmail won&#39;t display the entire patch inline=
.<br><br>On Thursday, January 19, 2017, Reshetova, Elena &lt;<a href=3D"mai=
lto:elena.reshetova@intel.com">elena.reshetova@intel.com</a>&gt; wrote:<br>=
&gt;&gt; On Wed, Jan 18, 2017 at 8:11 PM, Kees Cook &lt;<a href=3D"mailto:k=
eescook@chromium.org">keescook@chromium.org</a>&gt; wrote:<br>&gt;&gt; &gt;=
 On Wed, Jan 18, 2017 at 10:39 AM, David Windsor &lt;<a href=3D"mailto:dwin=
dsor@gmail.com">dwindsor@gmail.com</a>&gt;<br>&gt;&gt; wrote:<br>&gt;&gt; &=
gt;&gt; The relevant part of the patch has been cut off, but it appears tha=
t<br>&gt;&gt; &gt;&gt; you&#39;ve fixed some of the issues we identified ea=
rlier as corner cases<br>&gt;&gt; &gt;&gt; as to reference counting in net/=
.=C2=A0 In particular, inetpeer.c has its<br>&gt;&gt; &gt;&gt; own garbage =
collection system in place which frees shared objects when<br>&gt;&gt; &gt;=
&gt; their reference count became -1 (rather than 0).=C2=A0 The proposed<br=
>&gt;&gt; &gt;&gt; solution was to do a global +1 on this refcounting schem=
e, then<br>&gt;&gt; &gt;&gt; replace unsupported atomic_*() functions with =
appropriate refcount_*()<br>&gt;&gt; &gt;&gt; calls.<br>&gt;&gt; &gt;&gt;<b=
r>&gt;&gt; &gt;&gt; When submitting this to netdev, it may make sense to se=
parate out<br>&gt;&gt; &gt;&gt; these changes: first, do a global +1 (while=
 still using atomic_t),<br>&gt;&gt; &gt;&gt; then convert to refcount_t.=C2=
=A0 I&#39;m already working on this now, but I<br>&gt;&gt; &gt;&gt; didn&#3=
9;t know if you wanted to follow this approach or not.<br>&gt;&gt; &gt;<br>=
&gt;&gt; &gt; David, if you&#39;ve got the global +1 patches ready, let&#39=
;s start feeding<br>&gt;&gt; &gt; those to netdev ASAP. We can convert them=
 to refcount_t more easily<br>&gt;&gt; &gt; after that.<br>&gt;&gt; &gt;<br=
>&gt;&gt;<br>&gt;&gt; Alright, let me get them in order and I&#39;ll submit=
 them to netdev.=C2=A0 I<br>&gt;&gt; just wanted to make sure that an alter=
nate approach hadn&#39;t been<br>&gt;&gt; decided upon.<br>&gt;&gt;<br>&gt;=
<br>&gt; No, we haven&#39;t decided on that.<br>&gt; We had only some +1s, =
but not for all of it, so if you have a global +1, then it is even better!<=
br>&gt; Then we can drop +1 parts.<br>&gt;<br>&gt; And what do you mean by =
&quot; The relevant part of the patch has been cut off &quot; ? It is one h=
uge<br>&gt; patch but I got it in full mailed via list. Do you see it corru=
pted or?<br>&gt;<br>&gt; Best Regards,<br>&gt; Elena<br>&gt;

--001a11440f02b7ce9d054673e74e--
