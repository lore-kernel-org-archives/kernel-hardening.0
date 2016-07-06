Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAHgaXdKW4=y-PviWudtMAThuB=GEW-73RejSHRMYNVzLyxP+iA@mail.gmail.com>
References: <CAHgaXdKW4=y-PviWudtMAThuB=GEW-73RejSHRMYNVzLyxP+iA@mail.gmail.com>
From: Sandy Harris <sandyinchina@gmail.com>
Date: Wed, 6 Jul 2016 11:14:23 -0400
Message-ID: <CACXcFmm-maS9mpMhXF+boqZ5Os1KYzDpCzYepEwkNJcuuPdbhw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Looking for something to WORK ON
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Shubham Bansal <illusionist.neo@gmail.com> wrote:

> I want to start with linux kernel development and looking for some project
> where I can contribute.

Nearly all crypto and the address randomisation that is part of kernel
hardening depend on good random numbers, for Linux on the random(4)
driver. Getting it initialised early enough & well enough is an
extremely tricky problem. Several people have proposed solutions but
AFAIK none are complete and it might benefit from having fresh eyes
take a look, especially if you have a good background in crypto or
math.

Not all discussion is here; other relevant lists include
linux-crypto@vger.kernel.org and cryptography@metzdowd.com. People to
look for include the maintainer, tytso@mit.edu, the main person
working on the problem here, keescook@chromium.org, two guys who have
proposed drive rewrites that partly solve the problem, me and
smueller@chronox.de, and one with a lot of excellent comments,
jsd@av8n.com.
