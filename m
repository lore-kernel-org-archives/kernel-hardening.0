Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20111123165549.GB3463@albatros>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
	<20111121191811.GA24039@albatros>
	<20111122181310.GA4235@sergelap>
	<20111122192028.GA10458@albatros>
	<20111122201007.GA21722@sergelap>
	<20111123074510.GA2356@albatros>
	<20111123144928.GA3893@hallyn.com>
	<20111123165549.GB3463@albatros>
Date: Mon, 28 Nov 2011 10:12:50 -0800
Message-ID: <CAGXu5j+Y6JnTFhw3Fax_MYLvLLBMO5JOHLgaVyBB2LMsOwhUHw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [RFC] Make Yama pid_ns aware
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Serge Hallyn <serge.hallyn@canonical.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 23, 2011 at 8:55 AM, Vasiliy Kulikov <segoon@openwall.com> wrot=
e:
> On Wed, Nov 23, 2011 at 14:49 +0000, Serge E. Hallyn wrote:
>> Quoting Vasiliy Kulikov (segoon@openwall.com):
>> > Actually, what concerns me is not ptrace, but symlink/hardling
>> > protection. =A0There is no interaction between namespaces in case of
>> > containers via symlinks in the basic case. =A0In case of ptrace I don'=
t
>> > think the child ns may weaken the parent ns - child ns may not access
>> > processes of the parent namespace and everything it may ptrace is
>> > already inside of this ns.
>>
>> Oh, yes. =A0If you're saying the symlink protection shouldn't be
>> per-pidns, I agree it seems an odd fit.
>>
>> How about a version of this patch leaving symlink protection
>> out of pidns (maybe in user ns), and just putting ptrace
>> protection per-pidns?
>
> I don't think moving symlink/hardling from pid ns to user ns is a good
> idea as user ns is not matured yet. =A0Also we (Openwall) want to use Yam=
a
> almost as-is in our RHEL6 and RHEL5-based kernels with OpenVZ support
> which don't have user namespaces yet at all (yes, it is not a cause for
> mainline decisions :-) ).
>
> While user ns is not yet ready, I don't clearly see what is the division
> of security policies among namespaces including user namespace. =A0I had
> a view that all stuff related to processes (i.e. distinct processes in
> several ways) belongs to pid ns, all net stuff to net ns, etc. =A0If we
> differentiate user ns and pid ns, only strictly things handling pids
> (like kill(2), procfs, ptrace(2), etc.) belong to pid ns and all other
> process-related stuff (like credentials handling, these symlink/hardling
> things, etc.) belong to user namespaces.
>
> Can we probably leave them in pid ns for now and when user ns is matured
> just move it from pid ns to user ns? =A0Is it possible without breaking
> Yama's ABI (I think so)?

So it sounds like you'll send a new patch where only ptrace_scope is
tied to pidns?

-Kees

--=20
Kees Cook
ChromeOS Security
