Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: amluto@gmail.com
In-Reply-To: <CAB=4xho2b5fZV_jC15XW3mhOD9Z0QUMnV_UHy-P5EmQWfX59dA@mail.gmail.com>
References: <CACLa4puRJLUd6hAHO6zFYiqa5dFVum8eLmNMk_ef+=r8OGhjRg@mail.gmail.com>
	<CAB=4xho2b5fZV_jC15XW3mhOD9Z0QUMnV_UHy-P5EmQWfX59dA@mail.gmail.com>
Date: Mon, 21 May 2012 11:40:29 -0700
Message-ID: <CAObL_7EE+jkpTR9Yu3GwpLBt-X-MPXX=oR4rf1duiHBUu_gjyA@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Content-Type: multipart/alternative; boundary=bcaec54c527882bcc604c0903c43
Subject: [kernel-hardening] Re: seccomp and ptrace. what is the correct order?
To: Roland McGrath <mcgrathr@google.com>
Cc: keescook@chromium.org, serge.hallyn@canonical.com, Will Drewry <wad@chromium.org>, indan@nul.nu, Eric Paris <netdev@parisplace.org>, hpa@zytor.com, rdunlap@xenotime.net, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, markus@chromium.org, mingo@redhat.com, eric.dumazet@gmail.com, tglx@linutronix.de, pmoore@redhat.com, peterz@infradead.org, oleg@redhat.com, coreyb@linux.vnet.ibm.com, corbet@lwn.net, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, eparis@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

--bcaec54c527882bcc604c0903c43
Content-Type: text/plain; charset=ISO-8859-1

On May 21, 2012 8:25 PM, "Roland McGrath" <mcgrathr@google.com> wrote:
>
> From a security perspective I think the natural expectation would be that
> the seccomp check is on the values that will actually be used, without an
> intervening opportunity to change anything.

Certainly if the seccomp sandbox allows ptrace, this is important.

[Apologies if the Android app uses some evil mime type here.]

--Andy

--bcaec54c527882bcc604c0903c43
Content-Type: text/html; charset=ISO-8859-1

<p><br>
On May 21, 2012 8:25 PM, &quot;Roland McGrath&quot; &lt;<a href="mailto:mcgrathr@google.com">mcgrathr@google.com</a>&gt; wrote:<br>
&gt;<br>
&gt; From a security perspective I think the natural expectation would be that<br>
&gt; the seccomp check is on the values that will actually be used, without an<br>
&gt; intervening opportunity to change anything.</p>
<p>Certainly if the seccomp sandbox allows ptrace, this is important.</p>
<p>[Apologies if the Android app uses some evil mime type here.]</p>
<p>--Andy</p>

--bcaec54c527882bcc604c0903c43--
