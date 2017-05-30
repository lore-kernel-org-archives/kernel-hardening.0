Message-ID: <1496187633.17013.2.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Tue, 30 May 2017 19:40:33 -0400
In-Reply-To: <99069e11-dc84-8198-5d1c-f39b18ac9971@nmatt.com>
References: <20170529213800.29438-1-matt@nmatt.com>
	 <20170529213800.29438-3-matt@nmatt.com>
	 <20170529232640.16211960@alans-desktop>
	 <CAFUG7CdDd0Yfegb1S6_wNQzje4EuLE0jPdvOE=uSQL152meyjQ@mail.gmail.com>
	 <3738951f-7a4a-b37f-c695-21a2fcd45f76@schaufler-ca.com>
	 <0e078ce7-5b62-f27c-3920-efc2ffdf342b@nmatt.com>
	 <b0a29f23-4154-8f2f-98e7-0942612f0cdc@schaufler-ca.com>
	 <e1c9e4e8-5427-b4b6-aad2-72c88552a6af@nmatt.com>
	 <20170530132427.016053da@alans-desktop>
	 <2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
	 <1496169122.2164.21.camel@tycho.nsa.gov>
	 <CAFJ0LnHKKccbr-LqHHaFX5UNB20DzqfWDhvR-NTpgPedtkg0RA@mail.gmail.com>
	 <100b7d8c-7468-3122-4f59-3b0dcdf5dfc3@nmatt.com>
	 <1496175757.9871.6.camel@gmail.com>
	 <99069e11-dc84-8198-5d1c-f39b18ac9971@nmatt.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
To: Matt Brown <matt@nmatt.com>, Nick Kralevich <nnk@google.com>, Stephen Smalley <sds@tycho.nsa.gov>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Kees Cook <keescook@chromium.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, kernel-hardening@lists.openwall.com, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2017-05-30 at 19:00 -0400, Matt Brown wrote:
> On 5/30/17 4:22 PM, Daniel Micay wrote:
> > > Thanks, I didn't know that android was doing this. I still think
> > > this
> > > feature
> > > is worthwhile for people to be able to harden their systems
> > > against
> > > this attack
> > > vector without having to implement a MAC.
> > 
> > Since there's a capable LSM hook for ioctl already, it means it
> > could go
> > in Yama with ptrace_scope but core kernel code would still need to
> > be
> > changed to track the owning tty. I think Yama vs. core kernel
> > shouldn't
> > matter much anymore due to stackable LSMs.
> > 
> 
> What does everyone think about a v8 that moves this feature under Yama
> and uses
> the file_ioctl LSM hook?

It would only make a difference if it could be fully contained there, as
in not depending on tracking the tty owner.
