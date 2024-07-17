Return-Path: <kernel-hardening-return-21796-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 957DBC3DA62
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Jul 2024 17:59:57 +0000 (UTC)
Received: (qmail 5905 invoked by uid 550); 17 Jul 2024 17:59:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5882 invoked from network); 17 Jul 2024 17:59:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sempervictus-com.20230601.gappssmtp.com; s=20230601; t=1721239173; x=1721843973; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M8eaQLw9xNg9uFvBqSP89sHIql2nuE2XWi7tzCheL6U=;
        b=uieN7TQO5p6xG2w5e3+Xp1CN08ZNzwTlU8e3s87RlRjtARyCAIuleRTk9RmrI2Sy+W
         vcmFIwa6qiqpEOCyhA1z+wFD5bHxV/nx0dUD82fFYKxCcWHXDyx9OZCWOhZckhmEuTVx
         v3PbonoSYAPCQKJlL/KEzAFPbSoJHJmmIbnWOC7Rd0dEimNONCKGA95I3BiS5g0wf6GE
         9+Xln2NKlFNuoFDUla9D0re5pZ4yqQkmJhbnM8n7B1+fhiEbUQedWk84PRbOyxpS3hue
         msF0h6ZwBotXoVMcQOWHdBRVJlwtJYPxYkVsoa0GdNtR47KfLdESs/OHlvMY6tuk+Ldo
         3NIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721239173; x=1721843973;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M8eaQLw9xNg9uFvBqSP89sHIql2nuE2XWi7tzCheL6U=;
        b=BsAxmbmZqLqwtY/XZu81ZQFDgNjBftWYHTcZ1gnxrmw5E2FlknErdPDnjnfA2gzUi4
         CwliHMUaSB2yArZU94CPLZViBoYEW5AMr1J4u0t8QtamXKIWc5kkrYPe/0+PlfyznS/7
         SbfQYdwTXc8eoRxqaNJXxttuoGa17/bAq+4eJ/jaw6A0olrx7EThRQHejKhQJsSlD97H
         XBA6DzRfVN/YQKu4N5vpVxf19oJcDUGmQSoUZAZOIJyQ9KAZzsoEcLFySgVkvzHXNvah
         jedvp362h+NAmirKhyAOrhuMTkjBtxNXiJALg39t/ujBsJ0KZ87ZnNTgsP0GXqTrsz64
         AR5w==
X-Forwarded-Encrypted: i=1; AJvYcCUoyj0jB8YvrcTTksqnFoZ/wqoSYpe+SLjBqEnH4bF5jH6oDqiHSeKNIax96etczEm1qRA+q7YI2Cr8NGRRHdoiuE+Qm5yo1iPcrOEKYn773lTlgQ==
X-Gm-Message-State: AOJu0YwQzxBnFx2s+nKFCKcsdueR1SAqJtJ5CrrzFwmkbk3y7Ejo+Ksk
	ZPGTBzS6N77stLJEoWovT0izYugytMF1FMwnr9RB6KYTKSlffZj7ryjsINv6oOZjAJxgIOrROy5
	bjf/WcF1boLT6yJ98Y/g9XOsKZyrvPBGN5UiMXA==
X-Google-Smtp-Source: AGHT+IHEIU9neXftIncv5fOI1sUBbkOnPhjhzxfBjmV6pQBNc144cKpBZMqrxy2p/3onnp89VdZ5B8F9Pc4Udgj9/PQ=
X-Received: by 2002:a05:6902:278a:b0:e03:63d0:4516 with SMTP id
 3f1490d57ef6-e05ed7e2324mr2980262276.57.1721239173538; Wed, 17 Jul 2024
 10:59:33 -0700 (PDT)
MIME-Version: 1.0
References: <20240704190137.696169-1-mic@digikod.net> <55b4f6291e8d83d420c7d08f4233b3d304ce683d.camel@linux.ibm.com>
 <20240709.AhJ7oTh1biej@digikod.net> <9e3df65c2bf060b5833558e9f8d82dcd2fe9325a.camel@huaweicloud.com>
 <ee1ae815b6e75021709612181a6a4415fda543a4.camel@HansenPartnership.com>
 <E608EDB8-72E8-4791-AC9B-8FF9AC753FBE@sempervictus.com> <20240716.shaliZ2chohj@digikod.net>
In-Reply-To: <20240716.shaliZ2chohj@digikod.net>
From: Boris Lukashev <rageltman@sempervictus.com>
Date: Wed, 17 Jul 2024 13:59:22 -0400
Message-ID: <CAFUG7CfqAV0vzuFf_WL+wedeRzAfOyRGVWRVhfNBxS3FU78Tig@mail.gmail.com>
Subject: Re: [RFC PATCH v19 0/5] Script execution control (was O_MAYEXEC)
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Roberto Sassu <roberto.sassu@huaweicloud.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, "Theodore Ts'o" <tytso@mit.edu>, Alejandro Colomar <alx@kernel.org>, 
	Aleksa Sarai <cyphar@cyphar.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	James Morris <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>, 
	Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jordan R Abrahams <ajordanr@google.com>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Luca Boccassi <bluca@debian.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Wilcox <willy@infradead.org>, 
	Miklos Szeredi <mszeredi@redhat.com>, Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Steve Dower <steve.dower@python.org>, 
	Steve Grubb <sgrubb@redhat.com>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, 
	Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Apologies, sent from phone so plain-text wasn't flying.
To elaborate a bit on the quick commentary there - i'm the happy
camper behind most of the SSL shells, SSH stuff, AWS shells, and so on
in Metasploit. So please take the following with a grain of
tinfoil-hat salt as i'm well aware that there is no perfect defense
against these things which covers all bases while permitting any level
of sane operation in a general-purpose linux system (also work w/
GrapheneOS which is a far more suitable context for this sort of
thing). Having loosely followed the discussion thread, my offsec-brain
$0.02 are:

Shells are the provenance of the post-exploitation world - it's what
we want to get as a result of the exploit succeeding. So i think we
want to keep clear delineation between exploit and post-exp mitigation
as they're actually separate concerns of the killchain.
1. Command shells tend to differentiate from interpreted or binary
execution environments in their use of POSIX file descriptor
primitives such as pipes. How those are marshalled, chained, and
maintained (in a loop or whatever, hiding args, etc) are the only real
IOCs available at this tier for interdiction as observation of data
flow through the pipes is too onerous and complex. Target systems vary
in the post-exp surfaces exposed (/dev/tcp for example) with the
mechanics of that exposure necessitating adaptation of marshalling,
chaining, and maintenance to fit the environment; but the basic
premise of what forms a command shell cannot be mitigated without
breaking POSIX mechanics themselves - offsec devs are no different
from anyone else, we want our code to utilize architectural primitives
instead of undefined behavior for longevity and ecosystem
persistence/relevance.
2. The conversation about interpreted languages is probably a dead-end
unless you want to neuter the interpreter - check out Spencer
McIntyre's work re Python meterpreter or HDs/mine/etc on the PHP side.
The stagers, loaded contexts, execution patterns, etc are all
trivially modified to avoid detection (private versions not submitted
for free ripping by lazy commercial entities to the FOSS ecosystem,
yet). Dynamic code loading of interpreted languages is trivial and
requires no syscalls, just text/serialized IL/etc. The complexity of
loaded context available permits much more advanced functionality than
we get in most basic command interpreter shells - <advanced evasions
go here before doing something that'll get you caught> sort of thing.
3. Lastly, binary payloads such as Mettle have their own advantages re
portability, skipping over libc, etc but need to be "harnessed-in"
from say a command-injection exploit via memfd or similar. We haven't
published our memfd stagers while the relevant sysctl gets adopted
more widely, but we've had them for a long time (meaning real bad guys
have as well) and have other ways to get binary content into
executable memory or make memory containing it executable
(to-the-gills Grsec/PaX systems notwithstanding). IMO, interdiction of
the harnessed injection from a command context is the last time when
anything of use can be done at this layer unless we're sure that we
can trace all related and potentially async (not within the process
tree anyway) syscalls emanating from what happens next. Subsequent
actions are separate "remedial" workflows which is a wholly separate
philosophical discussion about how to handle having been compromised
already.

Security is very much not binary and in that vein of logic i think
that we should probably define our shades of gray as ranges of what we
want to protect/how and at what operational cost to then permit
"dial-in" knobs to actually garner adoption from a broad range of
systems outside the "real hardened efforts." At some point this turns
into "limit users to sftp or git shells" which is a perfectly valid
approach when the context permits that level of draconian restriction
but the architectural breakdown of "native command, interpreted
context, fully binary" shell types is pretty universal with new ones
being API access into runtimes of clouds (SSM/serial/etc) which have
their own set of limitations at execution and interface layers.
Organizing defensive functions to handle the primitives necessary for
each of these shell classes would likely help stratify/simplify this
conversation and allow for more granular tasking toward those specific
objectives.

Thanks,
-Boris


On Tue, Jul 16, 2024 at 1:48=E2=80=AFPM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
>
> (adding back other people in Cc)
>
> On Tue, Jul 16, 2024 at 01:29:43PM -0400, Boris Lukashev wrote:
> > Wouldn't count those shell chickens - awk alone is enough and we can
> > use ssh and openssl clients (all in metasploit public code). As one of
> > the people who makes novel shell types, I can assure you that this
> > effort is only going to slow skiddies and only until the rest of us
> > publish mitigations for this mitigation :)
>
> Security is not binary. :)
>
> Not all Linux systems are equals. Some hardened systems need this kind
> of feature and they can get guarantees because they fully control and
> trust their executable binaries (e.g. CLIP OS, chromeOS) or they
> properly sandbox them.  See context in the cover letter.
>
> awk is a script interpreter that should be patched too, like other Linux
> tools.
>
> >
> > -Boris (RageLtMan)
> >
> > On July 16, 2024 12:12:49 PM EDT, James Bottomley <James.Bottomley@Hans=
enPartnership.com> wrote:
> > >On Tue, 2024-07-16 at 17:57 +0200, Roberto Sassu wrote:
> > >> But the Clip OS 4 patch does not cover the redirection case:
> > >>
> > >> # ./bash < /root/test.sh
> > >> Hello World
> > >>
> > >> Do you have a more recent patch for that?
> > >
> > >How far down the rabbit hole do you want to go?  You can't forbid a
> > >shell from executing commands from stdin because logging in then won't
> > >work.  It may be possible to allow from a tty backed file and not from
> > >a file backed one, but you still have the problem of the attacker
> > >manually typing in the script.
> > >
> > >The saving grace for this for shells is that they pretty much do
> > >nothing on their own (unlike python) so you can still measure all the
> > >executables they call out to, which provides reasonable safety.
> > >
> > >James
> > >
