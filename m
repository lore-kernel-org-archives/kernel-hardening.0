Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4E456DA2.5080802@banquise.net>
Date: Fri, 12 Aug 2011 20:14:58 +0200
From: Simon Marechal <simon@banquise.net>
MIME-Version: 1.0
References: <20110606180806.GA3986@albatros> <20110606183358.GA14711@openwall.com> <20110608172307.GA3380@albatros> <20110612023916.GC14976@openwall.com> <20110724185036.GC3510@albatros> <20110726145016.GA8583@albatros> <20110729174725.GA2339@albatros> <20110804112331.GA2563@albatros> <20110810112522.GB30492@openwall.com> <20110810120439.GA7008@albatros> <20110810133409.GA31342@openwall.com>
In-Reply-To: <20110810133409.GA31342@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] procfs {tid,tgid,attr}_allowed mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Le 10/08/2011 15:34, Solar Designer a écrit :
> Perhaps run this by LKML as RFC and see what they think?  And be willing
> to revert to your old approach, with more hard-coding, now that you have
> this arguably overly complicated alternative.  Maybe it will convince
> Andrew Morton that something simpler and less flexible would be better.

Just my opinion, but the gid option is simple and to the point. More
complex solution will likely :
* not be used at all
* not be relevant to people with very specific needs anyway
* introduce bugs and/or vulnerabilities, either from the code or from
misconfigurations

Point #2 is important. Very specific needs should not be addressed in
this specific patch, it should be configured in something with a global
scope, such as a LSM.

I believe having effective security systems enabled by default is more
important than having generalistic and configurable systems nobody care
about. For example, being able to let a process choose the set of system
calls it should use is more useful to me than having SELinux loaded.
