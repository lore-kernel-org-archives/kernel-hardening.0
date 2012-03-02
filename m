Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: amluto@gmail.com
In-Reply-To: <CAGXu5jL0OXR5MOePFe=GT4_X5rdH8RNjQPqYXdbqsqfijUsEqA@mail.gmail.com>
References: <1330559620-23543-1-git-send-email-wad@chromium.org>
 <20120301233712.GS3990@outflux.net> <20120302114705.0a9542e138927897f16282ca@canb.auug.org.au>
 <CAGXu5jL0OXR5MOePFe=GT4_X5rdH8RNjQPqYXdbqsqfijUsEqA@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 1 Mar 2012 17:48:32 -0800
Message-ID: <CAObL_7H5i_oU2NORmV4TC3X2p3kUeN_ekBcd7PTDf0MuGOuGcQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v12 01/13] sk_run_filter: add support for custom load_pointer
To: Kees Cook <keescook@chromium.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm@linux-foundation.org, Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 1, 2012 at 4:57 PM, Kees Cook <keescook@chromium.org> wrote:
> Hi,
>
> On Thu, Mar 1, 2012 at 4:47 PM, Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>> Hi Kees,
>>
>> On Thu, 1 Mar 2012 15:37:12 -0800 Kees Cook <keescook@chromium.org> wrot=
e:
>>>
>>> Is it time to pull this into -next so more people can feel it? I brough=
t
>>> Andy Lutomirski's patches forward (needed to bump the prctl values), an=
d
>>> updated my git tree. If we're ready, here it is in all its request-pull
>>> format glory:
>>>
>>> The following changes since commit 2422c8368337196594265d52cad7316c9404=
bfcf:
>>> =A0 Stephen Rothwell (1):
>>> =A0 =A0 =A0 =A0 Add linux-next specific files for 20120301
>>
>> OK, not commenting on anything else, but I cannot merge that into
>> linux-next because it is based on yesterday's linux-next release and
>> linux-next (effectively) rebases every day ...
>>
>> Does this work depend on anything in linux-next? =A0Or could it be just
>> based off Linus' tree. =A0If it depends on other tree(s) merged into
>> linux-next, then you should base your tree on those tree(s) as long as
>> they never get rebased ...
>
> Unfortunately, yes, it does -- there were both ptrace changes and prctl c=
hanges.
>
> And at least the ptrace changes are, IIRC, in -mm, which has no tree.
> :P Given that, what's the best thing for me to do for this to be easy
> for you to pull?
>

IIRC the prctl changes are in -linus.  I can rebase my part onto them.

--Andy
