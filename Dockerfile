FROM debian:bullseye-slim

ENV PATH /usr/local/texlive/2019/bin/x86_64-linux:$PATH
ENV INSTALL_TL_NUX /tmp/install-tl-nux

RUN apt -y update

# pandoc
RUN apt -y --no-install-recommends install pandoc

# texlive
RUN apt -y --no-install-recommends install \
      perl \
      wget && \
    mkdir $INSTALL_TL_NUX && \
    wget -q -O - ftp://tug.org/texlive/historic/2019/install-tl-unx.tar.gz | \
    tar -xz -C $INSTALL_TL_NUX --strip-components=1 && \
    printf "%s\n" \
      "selected_scheme scheme-basic" \
      "option_doc 0" \
      "option_src 0" \
      "option_adjustrepo 0" \
      "option_autobackup 0" \
      "option_desktop_integration 0" \
      "option_file_assocs 0" \
        > $INSTALL_TL_NUX/texlive.profile && \
    $INSTALL_TL_NUX/install-tl --profile=$INSTALL_TL_NUX/texlive.profile && \
    tlmgr option repository http://mirror.ctan.org/systems/texlive/tlnet && \
    tlmgr update --self && tlmgr update --all && \
    tlmgr install \
      collection-basic collection-latex \
      collection-latexrecommended collection-latexextra \
      collection-fontsrecommended collection-langjapanese \
      latexmk luatexbase ctablestack fontspec luaotfload lualatex-math \
      sourcesanspro sourcecodepro && \
    rm -rf $INSTALL_TL_NUX && \
    apt remove -y perl wget

VOLUME ["/workdir", "/root/.pandoc/templates"]

WORKDIR /workdir
